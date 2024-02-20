Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D912FB38;
	Tue, 20 Feb 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708454714; cv=none; b=EBBQYnJaLCTd7nbxixhlQw8KhzcKtIYwLH7zhHhEqmoj3c8vIJCNV8r4jmbB881LdkS6cgzkYkA1ql+WiaVNSMnC+6y0lwJxXFk137Me4GDbO7zaRYt1fqacMKpqkBDpwY0P8IKQruOBsaRcMDHNUfAoEbLvOfwWcd29JIwi/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708454714; c=relaxed/simple;
	bh=HgfWxLr/9+EO2ZQL5YW8e8ugaLpMnYTtWU0gl55uFkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWDjvM2BAGEAKAH4EYzYFyFNt+vPKM60D0DhxR+AdsuiudoEF8zJtWJNBuRkOP7g6o559VlHvpPE61DFn5XPfHeIFV0AJzhIRBDDTkAgiazcKM6Eo8DxxB5YywFKYKMWy6M0fuZ0RuylcnKBuLgnhAIUGis4ZGHLt+pbCu4krfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AViV7+7K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZeIB15l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AViV7+7K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZeIB15l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AViV7+7K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZeIB15l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AViV7+7K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZeIB15l"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBA89210F0;
	Tue, 20 Feb 2024 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708454710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iWM41Q1rNjgHeEwYFmqtyc05mmicuDXwypkINyJYR8=;
	b=AViV7+7KWcPKNHDSOTCdnESYam89zGeUMYn1VJrjotWJsz7tab/LcBCK69AqO5WFXQFp2R
	daSzt8p5qwbMFM/v+Szowaof3uWTqbjgdqQb6S2EdvsQlF5sh1jS2cpOZY1xO1zXOdrXeD
	NQH63eEjXftnucxiGXFePsdSaGxWquA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708454710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iWM41Q1rNjgHeEwYFmqtyc05mmicuDXwypkINyJYR8=;
	b=yZeIB15lTAQMV1Y/OjErpx2RzzuJkgzrVSok+edPVQIG6YoMO8sHNOvr1iDdthH7gRK80Z
	eTWTYVe4z8MiCkAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708454710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iWM41Q1rNjgHeEwYFmqtyc05mmicuDXwypkINyJYR8=;
	b=AViV7+7KWcPKNHDSOTCdnESYam89zGeUMYn1VJrjotWJsz7tab/LcBCK69AqO5WFXQFp2R
	daSzt8p5qwbMFM/v+Szowaof3uWTqbjgdqQb6S2EdvsQlF5sh1jS2cpOZY1xO1zXOdrXeD
	NQH63eEjXftnucxiGXFePsdSaGxWquA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708454710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iWM41Q1rNjgHeEwYFmqtyc05mmicuDXwypkINyJYR8=;
	b=yZeIB15lTAQMV1Y/OjErpx2RzzuJkgzrVSok+edPVQIG6YoMO8sHNOvr1iDdthH7gRK80Z
	eTWTYVe4z8MiCkAQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 518D21358A;
	Tue, 20 Feb 2024 18:45:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 3jUrETbz1GXRZQAAn2gu4w
	(envelope-from <osalvador@suse.de>); Tue, 20 Feb 2024 18:45:10 +0000
Date: Tue, 20 Feb 2024 19:46:14 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ying.huang@intel.com,
	stable@vger.kernel.org, hyeongtak.ji@sk.com, hannes@cmpxchg.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com
Subject: Re: +
 mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch
 added to mm-hotfixes-unstable branch
Message-ID: <ZdTzdnYeyK4nXfGo@localhost.localdomain>
References: <20240220032539.63C25C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220032539.63C25C433F1@smtp.kernel.org>
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.29
X-Spamd-Result: default: False [-3.29 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-1.99)[95.00%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,linux-foundation.org:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

On Mon, Feb 19, 2024 at 07:25:38PM -0800, Andrew Morton wrote:
> From: Byungchul Park <byungchul@sk.com>
> Subject: mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
> Date: Fri, 16 Feb 2024 20:15:02 +0900
> 
> With numa balancing on, when a numa system is running where a numa node
> doesn't have its local memory so it has no managed zones, the following
> oops has been observed.  It's because wakeup_kswapd() is called with a
> wrong zone index, -1.  Fixed it by checking the index before calling
> wakeup_kswapd().
...
...

> 
> Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Reported-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
> Fixes: c574bbe917036 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

It's a shame that N_MEMORY can actually have no memory (e.g: memmap
consuming all zone's memory), but here we are:

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
