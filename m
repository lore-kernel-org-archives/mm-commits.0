Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970421E3784
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728063843; cv=none; b=FDjjmPWX8E6vZ2+e54H5eRsJr9tGDNQWLUuy2nnoqAktP2K+3vhdR7Ir2kPsyK9AhLYACNhqX4UxddHNkifOqyCVUHjeq65nSW64zUfveI/5Vvifn9CpwCkCuMke/xVfnt07h9H4SsIZCY4quuJQChrmlaX4qWUVxgoUMOLT8Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728063843; c=relaxed/simple;
	bh=Xb0w7WSdCF42gLav5qTwaGfhSnK9SxIdzeWsMss4ukk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZc/BVF+EoorP5kmN5RdKAGr4W03J6Gk/9xrP5bREoyQ1vwNZq0cDYA1THtRHe6opNWAMObL8vIx4n18buT5xb+HfKy1Id1S8URXu/5NYdt+06QXg08+TyRSbvPz/Vdi7p1RZGTmb6qTfsgC3hQlLaetRGUU7V+rRiX2dTaIfsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RnlFSdnL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RnlFSdnL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LNyT+1S2pJPBeeJamC8djeqSIOPCmDz+jNeQXbjZNps=; b=RnlFSdnLzfye/gVUhCGKnjwI0d
	Ecm0FVD+M1F0BVEXNgy/9FOoz8bNn2YtOEK+hmBLXbhNn7rJzK8t8j/WnyG2irF8fUcMyCbGxluVK
	RnJSC4A9xW60Er2YLDCImjf7Ikys7e3hsO6RPRdvorjCOQI/rZPNVpafKCZpTL2QVfbIqYzIh7oZs
	tO8WvUCGj6iH8tQLtTsOVnDun5LS6IrJwcJy5Lntm6t+HiwP5VpjGdY75C+8bAD0kVcHYSJqqqEq2
	u1S/PBHQmfPRS+pa8mCLJx3Lv7jPuvaoVjbFPHcWi896Lu4tVrpiPCtO8kMQUeoTQp+gKPkdhT2oI
	xV52e2DA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1swmLI-0000000Axaa-3ytn;
	Fri, 04 Oct 2024 17:43:52 +0000
Date: Fri, 4 Oct 2024 18:43:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, m.szyprowski@samsung.com, alexs@kernel.org
Subject: Re: + mm-add-pageanonnotksm-fix.patch added to mm-nonmm-unstable
 branch
Message-ID: <ZwApWPER7caIA_N3@casper.infradead.org>
References: <20241004173245.24B7BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004173245.24B7BC4CEC6@smtp.kernel.org>

On Fri, Oct 04, 2024 at 10:32:44AM -0700, Andrew Morton wrote:
>  static __always_inline void SetPageAnonExclusive(struct page *page)
>  {
> -	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
> +//	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
>  	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);

This instead please:

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 84746da35f79..2b2defc2732f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1131,14 +1131,14 @@ static __always_inline int PageAnonExclusive(const struct page *page)
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
