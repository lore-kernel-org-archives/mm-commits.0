Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA621215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188264; cv=none; b=ksy8P7CjrHqPJdhRgGNFCynL3AgD29+6bCiRsPJOL7FCaPynKe+/qTR+JKQl/nG+PUDX68ECl6VNu5YsDDNlazirLeHm88E/x1oixDXJNleqdoGLFEBb89ovbB+F/Pw+JU2An39nlSe3Z4AeCngY3fgE3V/lXBE23QXxaC6Ip2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188264; c=relaxed/simple;
	bh=AAEs6+PsOTV4hKcs88HgpccYHlb8r6+zkgFAMgfgPHU=;
	h=Date:To:From:Subject:Message-Id; b=fLB5CGRxp7S9SZzHqZVALeiZgmLn4dYO4nA5fRrn55bsXX8RIWX2twvIwoicZ/Bo5op1bNwWGovzNJJwRCc7dgBWNM5NVTRsg0mgool0p3JI281fivqpd3si9Gwqi4JQBERGIn+zKK/+npvctqNexB6nC+8qOZ8TzK7X0j8hqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y2x9Njj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y2x9Njj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33793C4CEEE;
	Mon, 17 Mar 2025 05:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188264;
	bh=AAEs6+PsOTV4hKcs88HgpccYHlb8r6+zkgFAMgfgPHU=;
	h=Date:To:From:Subject:From;
	b=Y2x9Njj29wgJfH4eB2kvWtOvqUyKny0q224umqV65xKq7+TzX/Otvfdj5NXWphQWF
	 6fWzni6SGFKCE5iOqHcih8zbhYXX6T4m1zoi4/RGPYI3/UpaFQoBQHq9cva1Xiir+K
	 HtmKHE8Zb1bO2CENvxAToG7eQAA+83sz2pfbMelk=
Date: Sun, 16 Mar 2025 22:11:03 -0700
To: mm-commits@vger.kernel.org,ericsalem@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fixed-typo.patch removed from -mm tree
Message-Id: <20250317051104.33793C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix typo
has been removed from the -mm tree.  Its filename was
     selftests-mm-fixed-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Salem <ericsalem@gmail.com>
Subject: selftests: mm: fix typo
Date: Sat, 8 Feb 2025 20:36:36 -0600

Fix misspelling.

Link: https://lkml.kernel.org/r/77e0e915-36c3-4c95-84b8-0b73aaa17951@gmail.com
Signed-off-by: Eric Salem <ericsalem@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-fixed-typo
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -323,7 +323,7 @@ int uffd_test_ctx_init(uint64_t features
 	ret = userfaultfd_open(&features);
 	if (ret) {
 		if (errmsg)
-			*errmsg = "possible lack of priviledge";
+			*errmsg = "possible lack of privilege";
 		return ret;
 	}
 
_

Patches currently in -mm which might be from ericsalem@gmail.com are


