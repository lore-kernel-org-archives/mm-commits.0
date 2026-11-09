Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257615;
	b=1EvTqFNJa7rh6h1+SkX9xY6g3vxGziqVDvEWdkS5h0jg8gr3YkRqTLoPAUjPfW4jij2m
	 P/zLsNpuBmvUh9uaIFMwFq55S1Shtk5/5TtOzfMKDQQQWyGHZtmWFjgK6eG88B68u5NPt
	 AarO0XXtGO3+FtmV9mB0s3EabTKMg/4e61Oz1IHPGQEJm7d3sJ2DH+mR7z8L/hdk6xNmP
	 /7MvbqneJhJzQOxi+BIJv6/c9pMyLBOg5p1PNnf6zjr2EAzTNqa3Q613weZV0phJxvs25
	 JAQHybc7c1xgRN6wuPF+O04DvziTbdiyBkRSUgHJaOl+xVORopHQpnDPXt+hpLpLPXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257615;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ov3VmP+qt4uBgWb5ReY4MEM3p12zqMEmOITWwIi8DkI=;
	b=qvloMeVRdSFeUNR3tGiTVToT9xyqDpcopyektxwe9fuQlsafnvL/yEi23MbWSKkM8lYr
	 Gwrgv7tC4pm8GBdHLEqP1ULu+TbRfX5AU2EmWsSdq0qbMKenTxCEaQWITwR2S3jfOL32u
	 cGSPDg2PJnna7nhAjkiBqJWDQJnuQjzkGJbs1hxselePYZaG2S8Yt61eO7KrzNjUaUz1e
	 bS9iPB4nVBoZ7OSGQmd1eZHZa5H9xWSkWhrBiOByaCuYcn9k04UylAtjnAUNdmlevwlkC
	 rzQIykVMTUGd6bXE6wzdI5z5Aej1j9bjXR8Ejr+JD8pojUfq533sJ6HNsCtKPQnthxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0IWRpMV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D594C606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0IWRpMV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD1F1F0089F;
	Mon,  9 Nov 2026 20:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257614;
	bh=ov3VmP+qt4uBgWb5ReY4MEM3p12zqMEmOITWwIi8DkI=;
	h=Date:To:From:Subject;
	b=0IWRpMV9T+CGSTEG93Wt3tHFHeZvkh/yELdTIyuSZgheowg7AtmirO1o0dQBd+yLD
	 jNLOvTPv/Maep5hbxoOtzz4ifr/kZS4/H7nVJaSDETvJLIf+zFlnbqH7p4BbC3MeY9
	 frBv5lDpmVZK2XYcoRgqntrgEvU9kwjoQxQUNNyk=
Date: Mon, 09 Nov 2026 12:53:34 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-inline-data-dinodes-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205334.9FD1F1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check inline data dinodes in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-inline-data-dinodes-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-inline-data-dinodes-in-online-filecheck.patch

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
Subject: ocfs2: check inline data dinodes in online filecheck
Date: Mon, 09 Nov 2026 20:21:17 +0800

Wire the inline-data guard and its three sub-checks into the filecheck
validator: allocated clusters on an inline inode, an id_count beyond the
space available in the inode block, and an i_size beyond id_count.

The size-without-clusters check now needs an explicit goto bail.  It
previously fell through to the bail label because it was the last check;
with checks following it, a later failure would overwrite its INVALIDINO
code and report the wrong reason.

The id_count maximum stays a signed int in the message.
ocfs2_max_inline_data_with_xattr() subtracts the unvalidated
i_xattr_inline_size and can go negative on small block sizes.

Link: https://lore.kernel.org/20261109122121.21473-28-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-inline-data-dinodes-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2105,6 +2105,40 @@ static int ocfs2_filecheck_validate_inod
 			     (unsigned long long)bh->b_blocknr,
 			     (unsigned long long)le64_to_cpu(di->i_size));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_inline_data(di)) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (ocfs2_dinode_has_inline_clusters(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: %u clusters\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le32_to_cpu(di->i_clusters));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(data->id_count),
+			     ocfs2_max_inline_data_with_xattr(sb, di));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size),
+			     le16_to_cpu(data->id_count));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 bail:
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

