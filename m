Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22011AA1E4
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011378; cv=none; b=l02mbFopGqt2lfWZN5k6UJijfbjWV+sIZ6HkVGGViHnW3oOFydxAACeWhlTdD2y5KomHzFq8ZI0wQ9Q0pomQd0ZAveTZ45RUMw95wdB4pjners33R2hSrtImBXdD8yc2CXX0ylgcCBrXNmAqDFuCM5MhRbDiR0FOB0ia8+b0iWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011378; c=relaxed/simple;
	bh=Ovlw9GP6A2SCwR9AFdTVJLP8ypYXigxSl9p1wUDwPPs=;
	h=Date:To:From:Subject:Message-Id; b=XcsbHrV2ZKFYxmjo2RtAI6RMxj47bCo6QmmFZjcn2iTTX1tE1kI5VAjQex6DlSKG2TbJnfqlcNElOWoCwWcPTTuWs64ArO5Dn1MWGvG4vsZuvqSOBu3wJ8XR/sZGhlZvn1xYHlirxYhieJ0UFHmKonbTXf9YreZ71H6zVciAqis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0Hvm4z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0Hvm4z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FCCC4CEE4;
	Mon, 12 May 2025 00:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011377;
	bh=Ovlw9GP6A2SCwR9AFdTVJLP8ypYXigxSl9p1wUDwPPs=;
	h=Date:To:From:Subject:From;
	b=h0Hvm4z3jETsk4S1Ps/fvFypOTbKS69aX7jliQ00o4hd2bXEt35H++aqMH9zT/nM9
	 7aoVtIKNc5aMs2jSnXF+Zlzf055B+x5I6pYH67LTyVoU2zS4AACdMHBFA6aUNalIqy
	 mC1FO1onVVGmYnw7QEGkP1pEod8zGCGjqmEFpuzc=
Date: Sun, 11 May 2025 17:56:17 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch removed from -mm tree
Message-Id: <20250512005617.B5FCCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove unnecessary NULL check before unregister_sysctl_table()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ni <nichen@iscas.ac.cn>
Subject: ocfs2: remove unnecessary NULL check before unregister_sysctl_table()
Date: Tue, 22 Apr 2025 15:30:51 +0800

unregister_sysctl_table() checks for NULL pointers internally.  Remove
unneeded NULL check here.

Link: https://lkml.kernel.org/r/20250422073051.1334310-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/stackglue.c~ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table
+++ a/fs/ocfs2/stackglue.c
@@ -691,8 +691,7 @@ static void __exit ocfs2_stack_glue_exit
 	memset(&locking_max_version, 0,
 	       sizeof(struct ocfs2_protocol_version));
 	ocfs2_sysfs_exit();
-	if (ocfs2_table_header)
-		unregister_sysctl_table(ocfs2_table_header);
+	unregister_sysctl_table(ocfs2_table_header);
 }
 
 MODULE_AUTHOR("Oracle");
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are


