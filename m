Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795478985;
	b=lESkud3MlTHVykTWbPuLCorO2imxubsxdA01ze6KdmkiPWEP1npLGt1bkdEr9gyhicTp
	 nbflKD0PGEvaHLXXa96nE2s1A3hPXtgj04FhQBwQh8rsMN/DJ/wN1Pn2cXNUv+EidHBoo
	 4mZy1JX/IPPEHhEdKDFZhkc0Sb/awmFSjwv2JB/tmo/Bp7F3OZ7xxweTk9SzKIuExG+ll
	 gEh1EMm+1B7N0hvh1sPf8JJb1tymMOOxl2y80uGCyNl8S38d8UcKrOpp6QqM+RqQwyS81
	 eDoJ4DDCTExbU2kLDfaFHWK+nQ8VCl+g67K9k85K+7aU742sFjMTWGPmgL0iuocTZtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478985;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PQwOPek/Fo0DK8lHz6xM8k1DF/Sp0BA1KreRR6w//0c=;
	b=Nl2cheCwBK0SWbDh0hmyXRri52hPb0aZJ+oMOhHwmWYtN/rk7/na3K5cMbAmM0ua2/yG
	 AyLVWgUQ/qO0Q80qtP0we5Q4T5FRXK4qO99SiazF55dJwNsCk58e5nidVuM9EgP8ZtkS2
	 8W3XpPW0+YXAb6VRQNsotc8rCbnmwr5WTnTdRBQlToO2Eeq3q5zey0HmSmKyQK+ftNmsi
	 cio7R5paT659q2hOat8V2EReMcLiIyzWfwSUXQmbCmq5A1gsuEBxXSxICSMwzFZKSSMEI
	 4lHoH6mqKxQmL+bwvQlrecppNC19LLPpG1vzFoObml87oNgcM6zI8MjT1WNVjJKtZVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="QCpucn/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2D1606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 00:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QCpucn/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11EB1F000C0;
	Tue, 24 Nov 2026 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795478984;
	bh=PQwOPek/Fo0DK8lHz6xM8k1DF/Sp0BA1KreRR6w//0c=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=QCpucn/zLiqQopaJMPR++Tw2rbB9WS7p97LX03qLZxMEfsjPeecvU4joaIqj42apu
	 NWms4oU1KxxtpjpS6JRxS9PFsDFdqDm3MuDd1Amk1f9u3ZKDnHxzz78AOB/wVXXr4w
	 EcEOAGeoQkKBmxyaajIDzK8thmd2sfKkIzm+2/cw=
Date: Mon, 23 Nov 2026 16:09:44 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,
	muchun.song@linux.dev,david@fromorbit.com,wangxuewen@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123055020.287151-1-wangxuewen_ky@163.com>
References: <20261123055020.287151-1-wangxuewen_ky@163.com>
Subject: + mm-shrinker-stop-counting-when-the-seq-buffer-overflows.patch added to mm-new branch
Message-Id: <20261124000944.B11EB1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: shrinker: stop counting when the seq buffer overflows
has been added to the -mm mm-new branch.  Its filename is
     mm-shrinker-stop-counting-when-the-seq-buffer-overflows.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-stop-counting-when-the-seq-buffer-overflows.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: mm: shrinker: stop counting when the seq buffer overflows
Date: Mon, 23 Nov 2026 13:50:20 +0800

The shrinker debugfs count file uses single_open(), so all memcg rows
belong to one seq_file record.  When the buffer overflows, seq_file grows
it and retries the entire record.  Queries for subsequent memcgs in an
overflowing pass cannot contribute to the final output.

Stop the traversal once seq_has_overflowed() is true, using the existing
mem_cgroup_iter_break() path to release the current memcg reference. 
Check for pending signals first to preserve the existing -EINTR priority. 
Leave the overflow state intact and return zero on overflow so seq_file
can grow the buffer and retry.

Tested in a single-node KVM guest with 1024 cgroups each caching 16
ordinary files on ext4.  Output remained 8865 bytes with three show
attempts.  Count callbacks fell from 3075 to 2472 (19.6%).  Six fresh
guests per variant each performed 101 full reads with no probes
registered.  The median of guest medians fell from 127.8 us to 114.0 us
(10.7%, about 13.7 us per read).

Link: https://patch.msgid.link/20261123055020.287151-1-wangxuewen_ky@163.com
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>

 mm/shrinker_debug.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/shrinker_debug.c~mm-shrinker-stop-counting-when-the-seq-buffer-overflows
+++ a/mm/shrinker_debug.c
@@ -84,6 +84,11 @@ static int shrinker_debugfs_count_show(s
 			ret = -EINTR;
 			break;
 		}
+
+		if (seq_has_overflowed(m)) {
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	kfree(count_per_node);
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-shrinker-stop-counting-when-the-seq-buffer-overflows.patch

