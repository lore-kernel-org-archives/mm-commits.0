From: akpm@linux-foundation.org
Subject: [patch 11/14] modpost: fix module autoloading for OF devices with generic compatible property
Date: Thu, 05 May 2016 16:22:29 -0700
Message-ID: <572bd5b5.QNm8N8dAIN5Q7/jA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbcEEXWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, p.zabel@pengutronix.de, computersforpeace@gmail.com, gregkh@linuxfoundation.org, javier@osg.samsung.com, rusty@rustcorp.com.au, sjoerd.simons@collabora.co.uk, stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: modpost: fix module autoloading for OF devices with generic compatible property

Since the wildcard at the end of OF module aliases is gone, autoloading of
modules that don't match a device's last (most generic) compatible value
fails.

For example the CODA960 VPU on i.MX6Q has the SoC specific compatible
"fsl,imx6q-vpu" and the generic compatible "cnm,coda960".  Since the
driver currently only works with knowledge about the SoC specific
integration, it doesn't list "cnm,cod960" in the module device table. 
This results in the device compatible
"of:NvpuT<NULL>Cfsl,imx6q-vpuCcnm,coda960" not matching the module alias
"of:N*T*Cfsl,imx6q-vpu" anymore, whereas before commit 2f632369ab79
("modpost: don't add a trailing wildcard for OF module aliases") it
matched the module alias "of:N*T*Cfsl,imx6q-vpu*".

This patch adds two module aliases for each compatible, one without the
wildcard and one with "C*" appended.

$ modinfo coda | grep imx6q
alias:          of:N*T*Cfsl,imx6q-vpuC*
alias:          of:N*T*Cfsl,imx6q-vpu

Fixes: 2f632369ab79 ("modpost: don't add a trailing wildcard for OF module aliases")
Link: http://lkml.kernel.org/r/1462203339-15340-1-git-send-email-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/file2alias.c |   69 ++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 24 deletions(-)

diff -puN scripts/mod/file2alias.c~modpost-fix-module-autoloading-for-of-devices-with-generic-compatible-property scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~modpost-fix-module-autoloading-for-of-devices-with-generic-compatible-property
+++ a/scripts/mod/file2alias.c
@@ -371,6 +371,49 @@ static void do_usb_table(void *symval, u
 		do_usb_entry_multi(symval + i, mod);
 }
 
+static void do_of_entry_multi(void *symval, struct module *mod)
+{
+	char alias[500];
+	int len;
+	char *tmp;
+
+	DEF_FIELD_ADDR(symval, of_device_id, name);
+	DEF_FIELD_ADDR(symval, of_device_id, type);
+	DEF_FIELD_ADDR(symval, of_device_id, compatible);
+
+	len = sprintf(alias, "of:N%sT%s", (*name)[0] ? *name : "*",
+		      (*type)[0] ? *type : "*");
+
+	if (compatible[0])
+		sprintf(&alias[len], "%sC%s", (*type)[0] ? "*" : "",
+			*compatible);
+
+	/* Replace all whitespace with underscores */
+	for (tmp = alias; tmp && *tmp; tmp++)
+		if (isspace(*tmp))
+			*tmp = '_';
+
+	buf_printf(&mod->dev_table_buf, "MODULE_ALIAS(\"%s\");\n", alias);
+	strcat(alias, "C");
+	add_wildcard(alias);
+	buf_printf(&mod->dev_table_buf, "MODULE_ALIAS(\"%s\");\n", alias);
+}
+
+static void do_of_table(void *symval, unsigned long size,
+			struct module *mod)
+{
+	unsigned int i;
+	const unsigned long id_size = SIZE_of_device_id;
+
+	device_id_check(mod->name, "of", size, id_size, symval);
+
+	/* Leave last one: it's the terminator. */
+	size -= id_size;
+
+	for (i = 0; i < size; i += id_size)
+		do_of_entry_multi(symval + i, mod);
+}
+
 /* Looks like: hid:bNvNpN */
 static int do_hid_entry(const char *filename,
 			     void *symval, char *alias)
@@ -684,30 +727,6 @@ static int do_pcmcia_entry(const char *f
 }
 ADD_TO_DEVTABLE("pcmcia", pcmcia_device_id, do_pcmcia_entry);
 
-static int do_of_entry (const char *filename, void *symval, char *alias)
-{
-	int len;
-	char *tmp;
-	DEF_FIELD_ADDR(symval, of_device_id, name);
-	DEF_FIELD_ADDR(symval, of_device_id, type);
-	DEF_FIELD_ADDR(symval, of_device_id, compatible);
-
-	len = sprintf(alias, "of:N%sT%s", (*name)[0] ? *name : "*",
-		      (*type)[0] ? *type : "*");
-
-	if (compatible[0])
-		sprintf(&alias[len], "%sC%s", (*type)[0] ? "*" : "",
-			*compatible);
-
-	/* Replace all whitespace with underscores */
-	for (tmp = alias; tmp && *tmp; tmp++)
-		if (isspace (*tmp))
-			*tmp = '_';
-
-	return 1;
-}
-ADD_TO_DEVTABLE("of", of_device_id, do_of_entry);
