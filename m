From: akpm@linux-foundation.org
Subject: [folded] w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:19:40 -0700
Message-ID: <201105262319.p4QNJecQ026492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net, szabolcs.gyurko@tlt.hu, mm-commits@vger.kernel.org


The patch titled
     w1: fix w1_ds2408.c printk formats
has been removed from the -mm tree.  Its filename was
     w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.p=
atch

This patch was dropped because it was folded into w1-add-1-wire-w1-ds24=
08-8-channel-addressable-switch-support.patch

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

origin.patch
w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
