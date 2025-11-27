Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB19303C9B
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764274457; cv=none; b=hwzdkaCD22lo5eDf8z6+XjFeOfFVPy/4tUkn1RkOmf8grgR53sdiNYWeuJdM1QJN+04Wbaz3Lr/i76tSF+p+Ht8cdTjJtDLHgrrhkm7YIx4jJ+Ng0nLEPG55bLnVkNdlZaPPt8XVnao4oyvvQRtr5+Flr0PE4JhHU7PXYAQF5U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764274457; c=relaxed/simple;
	bh=kVGUaey1YW3avOeGO19MB/4NHVCGPIAeFl9TjmhE3GE=;
	h=Date:To:From:Subject:Message-Id; b=Wup6EQVgp18XP0YZbqsVmxg5ULFbAAtqTnGbvxqojzj70WvAojG4nTPvlpSYnBtyhFl6ULckCsGqooOFnJBsh0uWW7OacxV1P+YAr1xylfw8YQcSi6y+YZ+2sveRwfW1qcYE59B2A5iL0+cTpg94UpJglUe634VRmbBqzVOFkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9G8LjCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9G8LjCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADEAC4CEF8;
	Thu, 27 Nov 2025 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764274457;
	bh=kVGUaey1YW3avOeGO19MB/4NHVCGPIAeFl9TjmhE3GE=;
	h=Date:To:From:Subject:From;
	b=X9G8LjCgaI+MoRZDWKqeBWb6MXjpth3hmJRTrFH68jSjEoeeGCTbKWIJRLmVGgG11
	 KOc33uhD8VCyaGG3Oj3w39dHmNAjwfKcaSVBL5A5bf9Gmtbee+fSfxMOKKEZ980MzH
	 KFROpIDe6PMeWQFp46JiV6PANe+pgMeRBcWmTBMo=
Date: Thu, 27 Nov 2025 12:14:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fvdl@google.com,david@kernel.org,guojinhui.liam@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch added to mm-new branch
Message-Id: <20251127201417.6ADEAC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Subject: mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
Date: Thu, 27 Nov 2025 17:25:12 +0800

When CONFIG_SPARSEMEM is disabled, the macro
sparse_vmemmap_init_nid_early(_nid, _use) passes two arguments, while the
actual function accepts only nid.  Drop the extra argument _use.

Link: https://lkml.kernel.org/r/20251127092512.278-1-guojinhui.liam@bytedance.com
Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem
+++ a/include/linux/mmzone.h
@@ -2289,7 +2289,7 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
-#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
+#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
_

Patches currently in -mm which might be from guojinhui.liam@bytedance.com are

mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch

