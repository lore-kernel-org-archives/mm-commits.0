Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EC01ABEBA
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733840518; cv=none; b=isKcZSXFeZpq4aY8Nbmd7fwH7UUmbEHUrOhx9sf4RNGlQDm/K3rwRtZlwClt5weEls5c4v3LcKMOYs/by80PArSQhsCJh69Lw/1ioD73vfDhYpAsRQO46K347PzCIJQUT6ntDvIot5MaemR7hPo2/X85FCNTgknPw5m7rWX0ck0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733840518; c=relaxed/simple;
	bh=Hu9p2t/Ssz++XgvGpNJBajgThQJW1eXRgEQLz4WKxEw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=mCqRtv0PkUeCIZfWc7LDzHcS8ZEZkzZQ7c2AAR9WtzyE5pxSl8L+uR3d6+loiiMKjoOXz5x78kjW9XH6t0VX12Fk3HFX9RKso+NXphsPe4SM7C/olYilRq1lGg7dVQ3bnwT2N7GQxFJlNBkVBf40YAqWlC0fIp2yGyxuhQPJcL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PVpiauBp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2Rtg6k+x; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jOxx45Yt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FCkPLJmj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PVpiauBp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2Rtg6k+x";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jOxx45Yt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FCkPLJmj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E2E971F441;
	Tue, 10 Dec 2024 14:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733840515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3e6Gw+GtMUW5Le5Fs2PMQsx0BgEfp+kV7BqOvnIa6s=;
	b=PVpiauBpY93NobS+6pt3JN2+/kYFAlHutxBHjU2uBhFqBE9z6fYWALxm79+CG9jWWub5Nr
	fCxzR7Ocv+L6xu8HMo6edAZ7CTgsqni3eFQh91pIlCIIRhh10Eqwap098z2WLtbINIGjgN
	ObvKZYwOf4W5AN1OV0+q/jMpPnliGLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733840515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3e6Gw+GtMUW5Le5Fs2PMQsx0BgEfp+kV7BqOvnIa6s=;
	b=2Rtg6k+xkwFHkymUeNEyBiGYvNtTanpwNrPwv7gsE0/bBcijKXtLoUfIzjza/rUrnYRcd9
	cAAoLekMkGg0gfAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733840514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3e6Gw+GtMUW5Le5Fs2PMQsx0BgEfp+kV7BqOvnIa6s=;
	b=jOxx45Ytk7TXvLGErOKHyNCj8VcESx8TLn50PrNaHKA3IbbDE41K2pGngvlsTBi5WxVtCQ
	qWDz/zkgW1Ax6hOGakQFGNxM8BnHauoZzzFsOdn9L77qRAprjju8a+C3Ml5zjnF8SISkOR
	7drbEPsrntkx68hZ4FPF4l/eV2dAp1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733840514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3e6Gw+GtMUW5Le5Fs2PMQsx0BgEfp+kV7BqOvnIa6s=;
	b=FCkPLJmjY5m1krkAnRJd7FlrY8fLH+eeXklY1qz8pfyPht/GnbmHsqZw+ts+ObOXHFMkpG
	KH/WgaKeMfs4zVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAE0813A15;
	Tue, 10 Dec 2024 14:21:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z71WNYJOWGdHEwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 10 Dec 2024 14:21:54 +0000
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Dec 2024 15:21:54 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
 david@redhat.com
Subject: Re: +
 mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
 added to mm-unstable branch
In-Reply-To: <20241210014748.A16A2C4CED1@smtp.kernel.org>
References: <20241210014748.A16A2C4CED1@smtp.kernel.org>
User-Agent: Roundcube Webmail
Message-ID: <db5386c99676aad0fb3013536a492554@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,nvidia.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 2024-12-10 02:47, Andrew Morton wrote:
> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: mm/page_alloc: don't use __GFP_HARDWALL when migrating pages
> via alloc_contig*()
> Date: Thu, 5 Dec 2024 10:05:07 +0100
> 
> Patch series "mm: don't use __GFP_HARDWALL when migrating remote 
> pages".
> 
> __GFP_HARDWALL means that we will be respecting the cpuset of the 
> caller
> when allocating a page.  However, when we are migrating remote 
> allocations
> (pages allocated from other context), the cpuset of the current context 
> is
> irrelevant.
> 
> For memory offlining + alloc_contig_*(), this is rather obvious.  There
> might be other such page migration users, let's start with the obvious
> ones.
> 
> 
> This patch (of 2):
> 
> We'll migrate pages allocated by other contexts; respecting the cpuset 
> of
> the alloc_contig*() caller when allocating a migration target does not
> make sense.
> 
> Drop the __GFP_HARDWALL.
> 
> Note that in an ideal world, migration code could figure out the cpuset
> of the original context and take that into consideration.
> 
> Link: 
> https://lkml.kernel.org/r/20241205090508.2095225-1-david@redhat.com
> Link: 
> https://lkml.kernel.org/r/20241205090508.2095225-2-david@redhat.com
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Same here:

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
