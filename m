Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912EB247280
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744850; cv=none; b=UEbdLWaluarzSCCQjZ6wIkvDFgk1hiJJWsiUR+mi/VFcg2ueA6dygRcr5KEHzDBcDpMJoJZd5MORL+HTJdSqPfLGI5mkSw+3+96UN/O9M/G1BDkvnJ4dLb3meQnEdboH9J79Giz0hq58nJNmABQgstk+isXutKFYPh68XKVjWJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744850; c=relaxed/simple;
	bh=XOyupWlinNhjW0F16tLI24XLrKizZeQUcz3ImjRk2NY=;
	h=Date:To:From:Subject:Message-Id; b=LwLnkOmcFqEXm2+wlwsDBDZko/WsF8aKR66Ueh7XDkaTmgQZbayrLgXNu9kMqZzIAsOH2O0zBbkwISNc03H10MFAeD6/NTZdpthbBcQunOPCz+C5RbKEMSG6b+m9O8gRQaTo5XERk39Qu9m+2O2eBvdjn1B5SkecxWPJ4kd/IT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3YrgQFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3YrgQFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD80C4CEF7;
	Sun, 29 Mar 2026 00:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744850;
	bh=XOyupWlinNhjW0F16tLI24XLrKizZeQUcz3ImjRk2NY=;
	h=Date:To:From:Subject:From;
	b=o3YrgQFOqHr+qLoGc6vk8Q+yOnOC8+kWdNKH1fKAZAx6y9KLuQyvmzT4a6QmV0Lvj
	 PtofYCLjY/CV7wq8d0iTmiKtgnNyviMGX4uaKuy/Q8VGxP65RZff0EJy9urhok7l5T
	 HwXHd/AoT7G68VtO6WJVOxgJABhyGm2es9AnDXSU=
Date: Sat, 28 Mar 2026 17:40:49 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch removed from -mm tree
Message-Id: <20260329004050.6BD80C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: make sure preservations do not span multiple NUMA nodes
has been removed from the -mm tree.  Its filename was
     kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: kho: make sure preservations do not span multiple NUMA nodes
Date: Mon, 9 Mar 2026 12:34:06 +0000

The KHO restoration machinery is not capable of dealing with preservations
that span multiple NUMA nodes.  kho_preserve_folio() guarantees the
preservation will only span one NUMA node since folios can't span multiple
nodes.

This leaves kho_preserve_pages().  While semantically kho_preserve_pages()
only deals with 0-order pages, so all preservations should be single page
only, in practice it combines preservations to higher orders for
efficiency.  This can result in a preservation spanning multiple nodes. 
Break up the preservations into a smaller order if that happens.

Link: https://lkml.kernel.org/r/20260309123410.382308-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-make-sure-preservations-do-not-span-multiple-numa-nodes
+++ a/kernel/liveupdate/kexec_handover.c
@@ -870,9 +870,17 @@ int kho_preserve_pages(struct page *page
 	}
 
 	while (pfn < end_pfn) {
-		const unsigned int order =
+		unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
+		/*
+		 * Make sure all the pages in a single preservation are in the
+		 * same NUMA node. The restore machinery can not cope with a
+		 * preservation spanning multiple NUMA nodes.
+		 */
+		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
+			order--;
+
 		err = kho_radix_add_page(tree, pfn, order);
 		if (err) {
 			failed_pfn = pfn;
_

Patches currently in -mm which might be from pratyush@kernel.org are


