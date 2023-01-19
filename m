Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C1BC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjASBV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjASBT6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F93A6CCD3
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C30A6176F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B41CC433EF;
        Thu, 19 Jan 2023 01:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090996;
        bh=5duJ2asCR8anvaV9IFZmz3DVDKutUfveVAyVNzPNAj8=;
        h=Date:To:From:Subject:From;
        b=YLooD4hAs/w2eDO8k4ngWmCA70hzO9med11gOMoe6lA585JLWoCJEbXwRdmxNT46E
         /Gp7an1bBJTk7Jo9pSEOUSPrrRW/uk0hOgZA1DNfa/imbk5SvJ/Z/Sk7gTf+s+74s5
         Sm4L5F+bKA3Zs7kuXFsxGc242AgYd5Cfjm6JWLWA=
Date:   Wed, 18 Jan 2023 17:16:35 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        Michael@MichaelLarabel.com, hannes@cmpxchg.org,
        andrea.righi@canonical.com, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-posix_fadv_noreuse.patch removed from -mm tree
Message-Id: <20230119011636.6B41CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: support POSIX_FADV_NOREUSE
has been removed from the -mm tree.  Its filename was
     mm-support-posix_fadv_noreuse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: support POSIX_FADV_NOREUSE
Date: Fri, 30 Dec 2022 14:52:52 -0700

This patch adds POSIX_FADV_NOREUSE to vma_has_recency() so that the LRU
algorithm can ignore access to mapped files marked by this flag.

The advantages of POSIX_FADV_NOREUSE are:
1. Unlike MADV_SEQUENTIAL and MADV_RANDOM, it does not alter the
   default readahead behavior.
2. Unlike MADV_SEQUENTIAL and MADV_RANDOM, it does not split VMAs and
   therefore does not take mmap_lock.
3. Unlike MADV_COLD, setting it has a negligible cost, regardless of
   how many pages it affects.

Its limitations are:
1. Like POSIX_FADV_RANDOM and POSIX_FADV_SEQUENTIAL, it currently does
   not support range. IOW, its scope is the entire file.
2. It currently does not ignore access through file descriptors.
   Specifically, for the active/inactive LRU, given a file page shared
   by two users and one of them having set POSIX_FADV_NOREUSE on the
   file, this page will be activated upon the second user accessing
   it. This corner case can be covered by checking POSIX_FADV_NOREUSE
   before calling folio_mark_accessed() on the read path. But it is
   considered not worth the effort.

There have been a few attempts to support POSIX_FADV_NOREUSE, e.g., [1]. 
This time the goal is to fill a niche: a few desktop applications, e.g.,
large file transferring and video encoding/decoding, want fast file
streaming with mmap() rather than direct IO.  Among those applications, an
SVT-AV1 regression was reported when running with MGLRU [2].  The
following test can reproduce that regression.

  kb=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
  kb=$((kb - 8*1024*1024))

  modprobe brd rd_nr=1 rd_size=$kb
  dd if=/dev/zero of=/dev/ram0 bs=1M

  mkfs.ext4 /dev/ram0
  mount /dev/ram0 /mnt/
  swapoff -a

  fallocate -l 8G /mnt/swapfile
  mkswap /mnt/swapfile
  swapon /mnt/swapfile

  wget http://ultravideo.cs.tut.fi/video/Bosphorus_3840x2160_120fps_420_8bit_YUV_Y4M.7z
  7z e -o/mnt/ Bosphorus_3840x2160_120fps_420_8bit_YUV_Y4M.7z
  SvtAv1EncApp --preset 12 -w 3840 -h 2160 \
               -i /mnt/Bosphorus_3840x2160.y4m

For MGLRU, the following change showed a [9-11]% increase in FPS,
which makes it on par with the active/inactive LRU.

  patch Source/App/EncApp/EbAppMain.c <<EOF
  31a32
  > #include <fcntl.h>
  35d35
  < #include <fcntl.h> /* _O_BINARY */
  117a118
  >             posix_fadvise(config->mmap.fd, 0, 0, POSIX_FADV_NOREUSE);
  EOF

[1] https://lore.kernel.org/r/1308923350-7932-1-git-send-email-andrea@betterlinux.com/
[2] https://openbenchmarking.org/result/2209259-PTS-MGLRU8GB57

Link: https://lkml.kernel.org/r/20221230215252.2628425-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h        |    2 ++
 include/linux/mm_inline.h |    3 +++
 mm/fadvise.c              |    5 ++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/fs.h~mm-support-posix_fadv_noreuse
+++ a/include/linux/fs.h
@@ -166,6 +166,8 @@ typedef int (dio_iodone_t)(struct kiocb
 /* File supports DIRECT IO */
 #define	FMODE_CAN_ODIRECT	((__force fmode_t)0x400000)
 
+#define	FMODE_NOREUSE		((__force fmode_t)0x800000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
--- a/include/linux/mm_inline.h~mm-support-posix_fadv_noreuse
+++ a/include/linux/mm_inline.h
@@ -599,6 +599,9 @@ static inline bool vma_has_recency(struc
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
 		return false;
 
+	if (vma->vm_file && (vma->vm_file->f_mode & FMODE_NOREUSE))
+		return false;
+
 	return true;
 }
 
--- a/mm/fadvise.c~mm-support-posix_fadv_noreuse
+++ a/mm/fadvise.c
@@ -80,7 +80,7 @@ int generic_fadvise(struct file *file, l
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
 		spin_lock(&file->f_lock);
-		file->f_mode &= ~FMODE_RANDOM;
+		file->f_mode &= ~(FMODE_RANDOM | FMODE_NOREUSE);
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
@@ -107,6 +107,9 @@ int generic_fadvise(struct file *file, l
 		force_page_cache_readahead(mapping, file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_NOREUSE;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_DONTNEED:
 		__filemap_fdatawrite_range(mapping, offset, endbyte,
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

