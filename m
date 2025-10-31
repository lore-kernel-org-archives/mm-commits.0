Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF804C81
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 01:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761873565; cv=none; b=l0r4HqtPaKKjCdRf1t61VObvlHMe3baFqoCZV+jlPqOPVUgZaE+JIhAXc2/ZFtM56r+X7RRcb2UvkFhDsrsNH1Rk1gUHBEP52egFb4vTIHWOsBhwLOyBAJLKhISeeGuuXw8+nrXH7jcpCCXtqjgMJDpMoX8kAHYZmYBpMz0fvGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761873565; c=relaxed/simple;
	bh=SQ80TDowXgJJtX069LT1s9JgXckq8qjh2VYz7eVmUco=;
	h=Date:To:From:Subject:Message-Id; b=bhJ47oHjLw2fMVCKcCTnn0mR2u5cK7kMiYse5UPjKBMMqmNTLH0wKLAbyvQMX3QJMQYNHAt4ttqhoc7GRwoXfVK1cTaytCkNmko4Vqpld1XjIUAnFw4dyxFa/9Zzaj/cjRwJrBB3qiREnfiOEFznttNqc11YJYfuIuPFxn8RQeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NW5w2JNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NW5w2JNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6BBC4CEFD;
	Fri, 31 Oct 2025 01:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761873564;
	bh=SQ80TDowXgJJtX069LT1s9JgXckq8qjh2VYz7eVmUco=;
	h=Date:To:From:Subject:From;
	b=NW5w2JNQ8bNye1eKuDR5roD/8nPPKhtaBT+R7ncQrjJzZ3ScMq5sDGiobMy5MSDNR
	 UBEd14QM5xVC6SHUrDsUfeanmTEQIiJjQdyFb4UFTgHmIB/Ug8oFTAaef4lx3ecXPK
	 yx1tRC/yXmjiV96+LKiSzpTBaYt5gCRq01Pg9Koo=
Date: Thu, 30 Oct 2025 18:19:23 -0700
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-hao-ge.patch added to mm-nonmm-unstable branch
Message-Id: <20251031011924.7B6BBC4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Hao Ge
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-hao-ge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-hao-ge.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mailmap: add entry for Hao Ge
Date: Thu, 30 Oct 2025 20:17:46 +0800

Use hao.ge@linux.dev as the main address for kernel work

Link: https://lkml.kernel.org/r/20251030121746.230747-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-hao-ge
+++ a/.mailmap
@@ -298,6 +298,7 @@ Hans de Goede <hansg@kernel.org> <hdegoe
 Hans Verkuil <hverkuil@kernel.org> <hverkuil@xs4all.nl>
 Hans Verkuil <hverkuil@kernel.org> <hverkuil-cisco@xs4all.nl>
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
+Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
_

Patches currently in -mm which might be from gehao@kylinos.cn are

codetag-debug-handle-existing-codetag_empty-in-mark_objexts_empty-for-slabobj_ext.patch
mailmap-add-entry-for-hao-ge.patch

