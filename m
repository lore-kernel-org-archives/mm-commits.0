Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508636494E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388538; cv=none; b=Lhjb6DTHgArcYyZqqaAwtb6OIo/YFM8e+s/glKBf6H7eHQBtHwKuHVHCvAkKNQClcc+HAKENAVJxvM1PZO/fxb3hKNiJZarBOcCvsGJrfMYn1C62Zw9fbdzPykz25gHD10oLiIT1adn78XrBDhqD+qeQ8lTrq/bYNYAFeW/a3hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388538; c=relaxed/simple;
	bh=eA3XrddmefeOzpcZt22R/LQsfXcrBbmDLVGDzkEDFbQ=;
	h=Date:To:From:Subject:Message-Id; b=nw6uNnhYrmdEBL4EDHuxSOVuCtAttO0Oj6h9MyuQaj1b49ukWKApmpUuLwYsgl9/em+a12XYi5+tCrAbxYf1xXsPECJ6v2cNftNnSxtfMCA4fWvPF6vqg3UcRL/utFiQADTCLwaiH+494gtIHFTOXvUxek2AhcmImaY8QLj/qRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJQcA8sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJQcA8sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEB9C2BCC6;
	Tue, 24 Mar 2026 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388538;
	bh=eA3XrddmefeOzpcZt22R/LQsfXcrBbmDLVGDzkEDFbQ=;
	h=Date:To:From:Subject:From;
	b=IJQcA8sR5pqOwf2kxMf4EsK1CIbmi/Z/vjfnSvwA9LL/79x8uttw278CnzSm/bRZ3
	 hzK4M3ME4doV+oQJ0K1519targS0Oka5UqR0Pgc8bwVUynExzI63DiRrf1naUp5ie7
	 NqJqXq4sNiOx+OyiLHng+YEkOO3Oa3HE+F+tNQ+k=
Date: Tue, 24 Mar 2026 14:42:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,mssola@mssola.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-the-comment-of-mod_zone_state.patch removed from -mm tree
Message-Id: <20260324214218.3CEB9C2BCC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix typo in the comment of mod_zone_state()
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-the-comment-of-mod_zone_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: : Miquel Sabaté Solà <mssola@mssola.com>
Subject: mm: fix typo in the comment of mod_zone_state()
Date: Fri, 20 Feb 2026 00:44:07 +0100

Use the proper function name, followed by parenthesis as usual.

Link: https://lkml.kernel.org/r/20260219234407.3261196-1-mssola@mssola.com
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-fix-typo-in-the-comment-of-mod_zone_state
+++ a/mm/vmstat.c
@@ -547,7 +547,7 @@ EXPORT_SYMBOL(__dec_node_page_state);
 #ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /*
  * If we have cmpxchg_local support then we do not need to incur the overhead
- * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ * that comes with local_irq_save/restore if we use this_cpu_try_cmpxchg().
  *
  * mod_state() modifies the zone counter state through atomic per cpu
  * operations.
_

Patches currently in -mm which might be from mssola@mssola.com are


