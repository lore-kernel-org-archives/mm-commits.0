From: akpm@linux-foundation.org
Subject: + hfs-add-sanity-check-for-file-name-length.patch added to -mm tree
Date: Mon, 14 Nov 2011 14:31:14 -0800
Message-ID: <201111142231.pAEMVF93014763@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:32977 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab1KNWbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 17:31:20 -0500
Received: by bkat2 with SMTP id t2so201654bka.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 14:31:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, clement.lecigne@netasq.com, eugeneteo@kernel.sg, greg@kroah.com, sandeen@redhat.com


The patch titled
     Subject: hfs: add sanity check for file name length
has been added to the -mm tree.  Its filename is
     hfs-add-sanity-check-for-file-name-length.patch

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
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hfs: add sanity check for file name length

On a corrupted file system the ->len field could be wrong leading to a
buffer overflow.

Reported-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/trans.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfs/trans.c~hfs-add-sanity-check-for-file-name-length fs/hfs/trans.c
--- a/fs/hfs/trans.c~hfs-add-sanity-check-for-file-name-length
+++ a/fs/hfs/trans.c
@@ -40,6 +40,8 @@ int hfs_mac2asc(struct super_block *sb, 
 
 	src = in->name;
 	srclen = in->len;
+	if (srclen > HFS_NAMELEN)
+		srclen = HFS_NAMELEN;
 	dst = out;
 	dstlen = HFS_MAX_NAMELEN;
 	if (nls_io) {
_
Subject: Subject: hfs: add sanity check for file name length

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
bio-change-some-signed-vars-to-unsigned.patch
paride-fix-potential-information-leak-in-pg_read.patch
hfs-add-sanity-check-for-file-name-length.patch

