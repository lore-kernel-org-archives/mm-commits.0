Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698C223C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837011; cv=none; b=Mbt/MHvFcAmFRPse9X8cbD9SlkqsxXfnGfIgH+z4LulzMsB/qe9v/at7hhtQrwRVSlIG3pZrE3k8kfxZNC4VCxVA549u7MB++85S0Z2XLEREJ1iU9hTIJCjiz1DM57pGP6/eI09jRFC5Uhiby/oDnM5fVZgtTig932t9xlBp648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837011; c=relaxed/simple;
	bh=3K2d8CNxMY+eeOaW4c0CnotP9rC7Hn1G5KNVVRTFkgY=;
	h=Date:To:From:Subject:Message-Id; b=YUm/YsWInP8weZjvJAsaYWrg9fW7rh1jvuVD25tf9aPz5c7wnJnavn1aUyKS5WF8z6o7PUYo2INzHK4o6tXD+UBNpw3s8FW7oNMMBrOVAZZls2l6ahSIl7MamTZiEELmzFjbWL967OY/648XBpVj2G6+QAcmqvAqeqbS89RAJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAyrS/cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAyrS/cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9A3C4CEDD;
	Tue, 14 Jan 2025 06:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837011;
	bh=3K2d8CNxMY+eeOaW4c0CnotP9rC7Hn1G5KNVVRTFkgY=;
	h=Date:To:From:Subject:From;
	b=BAyrS/cVWiw2NHRAMWoDB3Lbwl3YXHadhH/9sNNnjNsfzfIAYxIsuXL1LIM8O2lwE
	 aNFMxHfa3TjiMZIeo+gjp6XGbXZ9XxbgNtb3URLDnfd9Kq/pDrvP1l2Z6QmY8DYcvv
	 xtaECat5MdG3EEhaygRnkfe9xSlK87psZ4VOGPlY=
Date: Mon, 13 Jan 2025 22:43:30 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-select-arch_supports_pt_reclaim-if-x86_64.patch removed from -mm tree
Message-Id: <20250114064331.3E9A3C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64
has been removed from the -mm tree.  Its filename was
     x86-select-arch_supports_pt_reclaim-if-x86_64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64
Date: Wed, 4 Dec 2024 19:09:51 +0800

Now, x86 has fully supported the CONFIG_PT_RECLAIM feature, and reclaiming
PTE pages is profitable only on 64-bit systems, so select
ARCH_SUPPORTS_PT_RECLAIM if X86_64.

Link: https://lkml.kernel.org/r/841c1f35478d5354872d307888979c9e20de9c09.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig~x86-select-arch_supports_pt_reclaim-if-x86_64
+++ a/arch/x86/Kconfig
@@ -322,6 +322,7 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
+	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool y
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


