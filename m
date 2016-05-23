From: akpm@linux-foundation.org
Subject: [patch 22/84] nilfs2: replace __attribute__((packed)) with
 __packed
Date: Mon, 23 May 2016 16:23:23 -0700
Message-ID: <574390eb.2BbyBMSJuCN5TPhY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: replace __attribute__((packed)) with __packed

This fixes the following checkpatch.pl warning:

WARNING: __packed is preferred over __attribute__((packed))
#23: FILE: export.h:23:
+} __attribute__ ((packed));

Link: http://lkml.kernel.org/r/1461935747-10380-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/export.h~nilfs2-replace-__attribute__packed-with-__packed fs/nilfs2/export.h
--- a/fs/nilfs2/export.h~nilfs2-replace-__attribute__packed-with-__packed
+++ a/fs/nilfs2/export.h
@@ -20,6 +20,6 @@ struct nilfs_fid {
 
 	u32 parent_gen;
 	u64 parent_ino;
-} __attribute__ ((packed));
+} __packed;
 
 #endif
_
