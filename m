Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87379145B2E
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400055; cv=none; b=aiGkgwH4/4p6M9HolQueH33RZbakt4sOSFnZx3biMVtH3NltX0UWSHfSSYPNnHEAendYO3tkCfxbXf/GL/sGmKdgnOIlVTyTcsbzYj6TOIHMXRaYvz971xR5G22BAXw36hRZ+aOQNTXuUHCvvpHP0E8ACwxrU+b4DLwmiq8EYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400055; c=relaxed/simple;
	bh=MFQWcBlT+nD2Or9QjVSmXSeKctOHYsyfN/jAm4lYafY=;
	h=Date:To:From:Subject:Message-Id; b=gM60P8J72yNZWBVPBVDje0/PmWvp9rs7sc+j0pQaaiP0X+9PN25YNYXTBw2ICf2yqzpNlSNLCq3lbR2lA7Cn2Ehyx7HPS7eiRdhrmA383at4zWCRQlgPBUAOgCpML5l3xy5u19hB58YTAwvtdr4ZZOJ4gRTdOnOXqQabJvY2YTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TU7BZWFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TU7BZWFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E57C32789;
	Wed, 22 May 2024 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400055;
	bh=MFQWcBlT+nD2Or9QjVSmXSeKctOHYsyfN/jAm4lYafY=;
	h=Date:To:From:Subject:From;
	b=TU7BZWFg4nfHb0OYCu/UzWXXqbhyHCqkhWPIXV6vD9dbnn3MvyDTgliYQfO1oZpsA
	 sSd9sEFQMwBtbdhnqPkm4gRZ7AT1XtybcRDEZAo01HIL3EzzXDGhzX+UpT95tEYrlg
	 UJ8VpZ2VDBmPkfHdJ5SJ3nZqlDqwIRjxHf+ny2oM=
Date: Wed, 22 May 2024 10:47:34 -0700
To: mm-commits@vger.kernel.org,vdonnefort@google.com,dan.j.williams@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch added to mm-unstable branch
Message-Id: <20240522174735.13E57C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: sanity check that zeropages are not passed to RMAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: sanity check that zeropages are not passed to RMAP
Date: Wed, 22 May 2024 14:57:13 +0200

Using insert_page() we might have previously ended up passing the zeropage
into rmap code.  Make sure that won't happen again.

Note that we won't check the huge zeropage for now, which might still end
up in RMAP code.

Link: https://lkml.kernel.org/r/20240522125713.775114-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/rmap.h~mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap
+++ a/include/linux/rmap.h
@@ -200,6 +200,9 @@ static inline void __folio_rmap_sanity_c
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 
+	/* When (un)mapping zeropages, we should never touch ref+mapcount. */
+	VM_WARN_ON_FOLIO(is_zero_folio(folio), folio);
+
 	/*
 	 * TODO: we get driver-allocated folios that have nothing to do with
 	 * the rmap using vm_insert_page(); therefore, we cannot assume that
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch

