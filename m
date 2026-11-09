Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257601;
	b=49GT8TPH7woG+kioC0s3qu4R1bBnPYWRwqW+Mi/+X68zpNHl4HJsBZ2PpTjBo1XJvfAI
	 DEtPXy3mheekLs8LP/kiiELhfohRaBXMUa8LXjmC+uehFLi6rFwTychktnQAYgF0oC1Bk
	 NVLE1Uxf/dYN6zirgGT9QRjKbpzJhTN+hPmq7FCLwkKkiNuXZYXmbJG1wptlB5kqGXdlr
	 00jGpo6GDpVtKqtK5MyDaRNOUoWmUA+VY9ZOX4HGOyx2KGttjpgXSArMvadmxSJ09ZwJe
	 7VP7Ua3EQvGMtyTPeYdt6sF2JqHCrP+ajCA/2Goo1yIaafdiwXstKGjBF79zJRXs3Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257601;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7BmBQo5RSKa9JMH0IGOHdUyGB65Xu+KErC8Bco0pfCM=;
	b=MgbQMjw57cGk4/zXPukFtI4yTHLkDMRyJuhSO6csjZCo/mfdzlOMEVns3KJTVwJMPoL7
	 nLNnJknyxSz230rXBP+vyV0oPX7cSDRKbXLcd5mNwmulZ5NO2Ab4KFZIqxx6fAueH1mq+
	 99B0zklE+X5LJVjpm0o9CH8V5e4OT+I3ClhqsCuAByAcxl1kp0RowD/dzOr/zDPMNAHAF
	 ARO7FFtglQcxz1PKtkP0ZS/nIxglqhjvkMY8sFMqnpz+TuHY9QCBhr2UweiUPnxJU7X7V
	 m1blTUe0Wyg2wb9H0tlSeljgdRF0HGkOJt3KoqP4EiFYiyo7PBnI/IyNGFK2bfQEMQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TOsahtm+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC3606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TOsahtm+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC1E1F0089F;
	Mon,  9 Nov 2026 20:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257601;
	bh=7BmBQo5RSKa9JMH0IGOHdUyGB65Xu+KErC8Bco0pfCM=;
	h=Date:To:From:Subject;
	b=TOsahtm+Tb1Y5lGhqlXtWKvX3UUWZymplEe8vn9sPgJuuUjFoiYJjD/cNmhvC1J7X
	 Yfvfjm8FK0vs94k4amA8HKfFL165Zq9TwJ1aeVMZUDPeO4tmpfrkgwl4p/us4L18Vn
	 i3J7biydN5DbfENzPj0M7j0QSjJuRHwPVwQ0iDBs=
Date: Mon, 09 Nov 2026 12:53:20 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-extent-list-next-free-record-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205321.1CC1E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the extent list next free record check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-extent-list-next-free-record-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-extent-list-next-free-record-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: abstract the extent list next free record check
Date: Mon, 09 Nov 2026 20:21:11 +0800

Fold the l_next_free_rec against l_count test into a predicate and use it
in both ocfs2_validate_inode_block() and
ocfs2_filecheck_repair_inode_block(), which open-coded the same
comparison.  Repair keeps its ocfs2_dinode_has_extents() guard, which
selects the id2.i_list union arm.

This completes the split of ocfs2_validate_inode_block()'s open-coded
conditions into ocfs2_dinode_has_*() predicates.  Every return code and
log message stayed at its call site, so the normal validator still
escalates through ocfs2_error() while filecheck reports its own
OCFS2_FILECHECK_ERR_* codes without touching the error handling state.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-22-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-extent-list-next-free-record-check
+++ a/fs/ocfs2/inode.c
@@ -278,6 +278,12 @@ static bool ocfs2_dinode_has_oversized_e
 		ocfs2_extent_recs_per_inode(sb);
 }
 
+static bool ocfs2_dinode_has_bad_extent_next_free(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+		le16_to_cpu(di->id2.i_list.l_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1939,7 +1945,7 @@ int ocfs2_validate_inode_block(struct su
 					 ocfs2_extent_recs_per_inode(sb));
 			goto bail;
 		}
-		if (next_free > count) {
+		if (ocfs2_dinode_has_bad_extent_next_free(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
 					 (unsigned long long)bh->b_blocknr, next_free, count);
@@ -2110,7 +2116,7 @@ static int ocfs2_filecheck_repair_inode_
 	}
 
 	if (ocfs2_dinode_has_extents(di) &&
-	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+	    ocfs2_dinode_has_bad_extent_next_free(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
 		mlog(ML_ERROR,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch
ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch
ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch
ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch
ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch
ocfs2-abstract-the-dinode-suballoc-slot-checks.patch
ocfs2-abstract-the-dinode-suballoc-bit-check.patch
ocfs2-abstract-the-dinode-orphaned-slot-check.patch
ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch
ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch
ocfs2-abstract-the-inline-data-id_count-bound-check.patch
ocfs2-abstract-the-inline-data-i_size-bound-check.patch
ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch
ocfs2-abstract-the-fast-symlink-nul-termination-check.patch
ocfs2-abstract-the-chain-list-dinode-guard-and-count-check.patch
ocfs2-abstract-the-chain-list-next-free-record-check.patch
ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch
ocfs2-abstract-the-dinode-refcount-location-check.patch
ocfs2-abstract-the-zero-extent-list-count-check.patch
ocfs2-abstract-the-oversized-extent-list-count-check.patch
ocfs2-abstract-the-extent-list-next-free-record-check.patch
ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch
ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch
ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch
ocfs2-check-inline-data-dinodes-in-online-filecheck.patch
ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch
ocfs2-check-chain-list-dinodes-in-online-filecheck.patch
ocfs2-check-dinode-refcount-location-in-online-filecheck.patch
ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

