From: akpm@linux-foundation.org
Subject: + w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.patch added to -mm tree
Date: Fri, 13 May 2011 10:53:32 -0700
Message-ID: <201105131745.p4DHjug6029944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab1EMRq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 May 2011 13:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net, szabolcs.gyurko@tlt.hu


The patch titled
     w1: fix w1_ds2408.c printk formats
has been added to the -mm tree.  Its filename is
     w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1: fix w1_ds2408.c printk formats
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

=46ix printk format warnings (on i386):
(in w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch)

drivers/w1/slaves/w1_ds2408.c:79: warning: format '%lu' expects type 'l=
ong unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:92: warning: format '%lu' expects type 'l=
ong unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:106: warning: format '%lu' expects type '=
long unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:120: warning: format '%lu' expects type '=
long unsigned int', but argument 7 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2408.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2408.c~w1-add-1-wire-w1-ds2408-8-chann=
el-addressable-switch-support-fix drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~w1-add-1-wire-w1-ds2408-8-channel-a=
ddressable-switch-support-fix
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -77,7 +77,7 @@ static ssize_t w1_f29_read_state(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
@@ -90,7 +90,7 @@ static ssize_t w1_f29_read_output(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
@@ -104,7 +104,7 @@ static ssize_t w1_f29_read_activity(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
@@ -118,7 +118,7 @@ static ssize_t w1_f29_read_cond_search_m
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

linux-next.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
