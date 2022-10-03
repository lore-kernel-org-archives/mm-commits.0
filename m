Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C502DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJCVaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJCV3t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2E057555
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C91601D7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE7C433C1;
        Mon,  3 Oct 2022 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832149;
        bh=BXHt9A9Dlo6mucM2/e8xtqU1bC82I1EIkAe84yd8GLY=;
        h=Date:To:From:Subject:From;
        b=m2vrzIFBncuT2F7nmpn/QNV3BJinn0a5NDTpjSuK4g5pqg7TB8Lt1MOq5Y0xeemqF
         6w73YRq1dpVXtRiPL+QQGNInPe5pqMTIWKkWw3sX6KSht3/I5m2XZvA2biXJsW/M0j
         ZwKeg0ZB8S2stGHJjovoglACeNNWohQ+1XI3SpnI=
Date:   Mon, 03 Oct 2022 14:22:28 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        keescook@chromium.org, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        gustavoars@kernel.org, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch removed from -mm tree
Message-Id: <20221003212229.19AE7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Gustavo A. R. Silva" <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
Date: Sat, 3 Sep 2022 00:59:36 +0100

Zero-length arrays are deprecated and we are moving towards adopting C99
flexible-array members, instead.  So, replace zero-length array
declarations in a couple of structures and unions with the new
DECLARE_FLEX_ARRAY() helper macro.

This helper allows for a flexible-array member in a union and as only
member in a structure.

Also, this addresses multiple warnings reported when building with
Clang-15 and -Wzero-length-array.

Lastly, this will also help memcpy (in a coming hardening update) execute
proper bounds-checking on variable length object i_symlink at
fs/ocfs2/namei.c:1973:

fs/ocfs2/namei.c:
1973                 memcpy((char *) fe->id2.i_symlink, symname, l);

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/197
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Link: https://lkml.kernel.org/r/YxKY6O2hmdwNh8r8@work
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-replace-zero-length-arrays-with-declare_flex_array-helper
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -527,7 +527,7 @@ struct ocfs2_extent_block
  * value -1 (0xFFFF) is OCFS2_INVALID_SLOT.  This marks a slot empty.
  */
 struct ocfs2_slot_map {
-/*00*/	__le16 sm_slots[0];
+/*00*/	DECLARE_FLEX_ARRAY(__le16, sm_slots);
 /*
  * Actual on-disk size is one block.  OCFS2_MAX_SLOTS is 255,
  * 255 * sizeof(__le16) == 512B, within the 512B block minimum blocksize.
@@ -548,7 +548,7 @@ struct ocfs2_extended_slot {
  * i_size.
  */
 struct ocfs2_slot_map_extended {
-/*00*/	struct ocfs2_extended_slot se_slots[0];
+/*00*/	DECLARE_FLEX_ARRAY(struct ocfs2_extended_slot, se_slots);
 /*
  * Actual size is i_size of the slot_map system file.  It should
  * match s_max_slots * sizeof(struct ocfs2_extended_slot)
@@ -727,7 +727,7 @@ struct ocfs2_dinode {
 		struct ocfs2_extent_list	i_list;
 		struct ocfs2_truncate_log	i_dealloc;
 		struct ocfs2_inline_data	i_data;
-		__u8               		i_symlink[0];
+		DECLARE_FLEX_ARRAY(__u8,	i_symlink);
 	} id2;
 /* Actual on-disk size is one block */
 };
@@ -892,7 +892,7 @@ struct ocfs2_group_desc
 /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
 	__le64   bg_reserved2;
 /*40*/	union {
-		__u8    bg_bitmap[0];
+		DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
 		struct {
 			/*
 			 * Block groups may be discontiguous when
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are


