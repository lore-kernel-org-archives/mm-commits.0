From: akpm@linux-foundation.org
Subject: + drivers-hid-introduce-missing-kfree.patch added to -mm tree
Date: Mon, 03 Aug 2009 15:54:10 -0700
Message-ID: <200908032254.n73MsBpf000714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbZHCWyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 18:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jkosina@suse.cz


The patch titled
     drivers/hid: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-hid-introduce-missing-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hid: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-debug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hid/hid-debug.c~drivers-hid-introduce-missing-kfree drivers/hid/hid-debug.c
--- a/drivers/hid/hid-debug.c~drivers-hid-introduce-missing-kfree
+++ a/drivers/hid/hid-debug.c
@@ -928,6 +928,7 @@ static int hid_debug_events_open(struct 
 
 	if (!(list->hid_debug_buf = kzalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_KERNEL))) {
 		err = -ENOMEM;
+		kfree(list);
 		goto out;
 	}
 	list->hdev = (struct hid_device *) inode->i_private;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-media-video-gspca-introduce-missing-kfree.patch
drivers-ata-use-resource_size.patch
drivers-mmc-correct-error-handling-code.patch
drivers-rtc-correct-error-handling-code.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch
drivers-rtc-introduce-missing-kfree.patch
drivers-hid-introduce-missing-kfree.patch
drivers-md-introduce-missing-kfree.patch
drivers-ata-introduce-missing-kfree.patch

