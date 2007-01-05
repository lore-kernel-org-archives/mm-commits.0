From: akpm@osdl.org
Subject: + uml-use-list_head-where-possible.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:19 -0800
Message-ID: <200701052013.l05KDJDm031072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbXAEUNY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: use LIST_HEAD where possible
has been added to the -mm tree.  Its filename is
     uml-use-list_head-where-possible.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: use LIST_HEAD where possible
From: Jeff Dike <jdike@addtoit.com>

A couple of list_head declarations can be improved through the use of
LIST_HEAD().

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/mconsole_kern.c |    2 +-
 arch/um/drivers/port_kern.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-use-list_head-where-possible arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-use-list_head-where-possible
+++ a/arch/um/drivers/mconsole_kern.c
@@ -371,7 +371,7 @@ struct unplugged_pages {
 
 static DECLARE_MUTEX(plug_mem_mutex);
 static unsigned long long unplugged_pages_count = 0;
-static struct list_head unplugged_pages = LIST_HEAD_INIT(unplugged_pages);
+static LIST_HEAD(unplugged_pages);
 static int unplug_index = UNPLUGGED_PER_PAGE;
 
 static int mem_config(char *str, char **error_out)
diff -puN arch/um/drivers/port_kern.c~uml-use-list_head-where-possible arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-use-list_head-where-possible
+++ a/arch/um/drivers/port_kern.c
@@ -130,7 +130,7 @@ static int port_accept(struct port_list 
 }
 
 static DECLARE_MUTEX(ports_sem);
-static struct list_head ports = LIST_HEAD_INIT(ports);
+static LIST_HEAD(ports);
 
 void port_work_proc(struct work_struct *unused)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
