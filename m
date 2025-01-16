Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C014B094
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737049517; cv=none; b=AGUdd4gHPSMbGk+wajgKknK4VlECfl9lDth+w3leYhIN5jufZk648zamKsMdIGcdbJCaA0bkyuIjNaZHHl7IRk/uqSTdPCruWZVd5O8X4qkfLBd1WC2415bll0LzBRw+29VzHiq4hgEHMHTAExl+ndFqhydJG1jZcXtnhmPbOwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737049517; c=relaxed/simple;
	bh=Fi9JffUlwQ1LVAjCB4muAyuuSjkfsgRdA5NxABKz0ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qn/bafYLtRNzS0IOJovmJrl3B4Jlt2Epixwf7w8oW7xw8g1qpPGfAHArMXUwcxKJvVGMjSHvcvQTc6sacR8NT3fv8mn+2JxIBkJQaC+mb84nBS4h18vDpjhORDQULrJ9pZwNeMvt09A8ERZPnDaZLMCIHGCKSQ8GIIDtX7XNnLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zm0kQC94; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=awAZjsIP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zm0kQC94; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=awAZjsIP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zm0kQC94";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="awAZjsIP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zm0kQC94";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="awAZjsIP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB7C71F381;
	Thu, 16 Jan 2025 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737049512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tF4el9CdP22MluKczcDx++l4RelAOl7jou0cYmAQjo=;
	b=zm0kQC94wJkZ5C17/6js1K9dfnREiLSFcqA2q3JEqhgzUGYgsK9DUZLfy4ZACGRY7/3Ahg
	dOApUOg3yCRXw+7LAYauRO5lkPzxedbz1H6led41F+O1iKx+VPpnqNhDeqHVq7H0Cf80Ig
	sW5nZVvZcbrvju0gZayW8UU6vvrfL6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737049512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tF4el9CdP22MluKczcDx++l4RelAOl7jou0cYmAQjo=;
	b=awAZjsIPma1DnFRnFrG4SDm9C00k3oRpANjtD9+xBRHeaHcORWrWGgVGeepKJRyogRsnHE
	P3xxXbHdMhgQ2JBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zm0kQC94;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=awAZjsIP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737049512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tF4el9CdP22MluKczcDx++l4RelAOl7jou0cYmAQjo=;
	b=zm0kQC94wJkZ5C17/6js1K9dfnREiLSFcqA2q3JEqhgzUGYgsK9DUZLfy4ZACGRY7/3Ahg
	dOApUOg3yCRXw+7LAYauRO5lkPzxedbz1H6led41F+O1iKx+VPpnqNhDeqHVq7H0Cf80Ig
	sW5nZVvZcbrvju0gZayW8UU6vvrfL6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737049512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tF4el9CdP22MluKczcDx++l4RelAOl7jou0cYmAQjo=;
	b=awAZjsIPma1DnFRnFrG4SDm9C00k3oRpANjtD9+xBRHeaHcORWrWGgVGeepKJRyogRsnHE
	P3xxXbHdMhgQ2JBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86F8313AEF;
	Thu, 16 Jan 2025 17:45:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s0brIKhFiWfnZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jan 2025 17:45:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 285A8A08E0; Thu, 16 Jan 2025 18:45:08 +0100 (CET)
Date: Thu, 16 Jan 2025 18:45:08 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, 
	shikemeng@huaweicloud.com, linux@roeck-us.net, jack@suse.cz, jimzhao.ai@gmail.com
Subject: Re: [failures]
 mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh.patch
 removed from -mm tree
Message-ID: <mxrqnjnx3hoby3mghzmfsxewtfljjmx3h7jmq2jbwfxk2x3pm2@s3q2kuizufai>
References: <20250113232246.B2512C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113232246.B2512C4CEE2@smtp.kernel.org>
X-Rspamd-Queue-Id: AB7C71F381
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,infradead.org:email,roeck-us.net:email];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,infradead.org,huaweicloud.com,roeck-us.net,suse.cz,gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,linux-foundation.org:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.51
X-Spam-Flag: NO

Hello Andrew!

On Mon 13-01-25 15:22:46, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh
> has been removed from the -mm tree.  Its filename was
>      mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh.patch
> 
> This patch was dropped because it had testing failures

Can you please put this patch back? We have been debugging with Guenter the
problem and in the end it seems to be a HW issue (in emulation of
big-endian arch) that was just triggered by timing / code changes
introduced by this patch [1]. Thanks!

								Honza

[1] https://lore.kernel.org/all/897b426d-7ca7-4bfe-8342-d2af910f8202@roeck-us.net

> 
> ------------------------------------------------------
> From: Jim Zhao <jimzhao.ai@gmail.com>
> Subject: mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh
> Date: Thu, 21 Nov 2024 18:05:39 +0800
> 
> Address the feedback from 39ac99852fca ("mm/page-writeback: raise
> wb_thresh to prevent write blocking with strictlimit)".  The wb_thresh
> bumping logic is scattered across wb_position_ratio, __wb_calc_thresh, and
> wb_update_dirty_ratelimit.  For consistency, consolidate all wb_thresh
> bumping logic into __wb_calc_thresh.
> 
> Link: https://lkml.kernel.org/r/20241121100539.605818-1-jimzhao.ai@gmail.com
> Signed-off-by: Jim Zhao <jimzhao.ai@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page-writeback.c |   53 ++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 37 deletions(-)
> 
> --- a/mm/page-writeback.c~mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh
> +++ a/mm/page-writeback.c
> @@ -942,26 +942,25 @@ static unsigned long __wb_calc_thresh(st
>  	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
>  
>  	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
> -	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
> -	if (wb_thresh > wb_max_thresh)
> -		wb_thresh = wb_max_thresh;
>  
>  	/*
> -	 * With strictlimit flag, the wb_thresh is treated as
> -	 * a hard limit in balance_dirty_pages() and wb_position_ratio().
> -	 * It's possible that wb_thresh is close to zero, not because
> -	 * the device is slow, but because it has been inactive.
> -	 * To prevent occasional writes from being blocked, we raise wb_thresh.
> +	 * It's very possible that wb_thresh is close to 0 not because the
> +	 * device is slow, but that it has remained inactive for long time.
> +	 * Honour such devices a reasonable good (hopefully IO efficient)
> +	 * threshold, so that the occasional writes won't be blocked and active
> +	 * writes can rampup the threshold quickly.
>  	 */
> -	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
> -		unsigned long limit = hard_dirty_limit(dom, dtc->thresh);
> -		u64 wb_scale_thresh = 0;
> -
> -		if (limit > dtc->dirty)
> -			wb_scale_thresh = (limit - dtc->dirty) / 100;
> -		wb_thresh = max(wb_thresh, min(wb_scale_thresh, wb_max_thresh / 4));
> +	if (thresh > dtc->dirty) {
> +		if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT))
> +			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 100);
> +		else
> +			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
>  	}
>  
> +	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
> +	if (wb_thresh > wb_max_thresh)
> +		wb_thresh = wb_max_thresh;
> +
>  	return wb_thresh;
>  }
>  
> @@ -969,6 +968,7 @@ unsigned long wb_calc_thresh(struct bdi_
>  {
>  	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
>  
> +	domain_dirty_avail(&gdtc, true);
>  	return __wb_calc_thresh(&gdtc, thresh);
>  }
>  
> @@ -1145,12 +1145,6 @@ static void wb_position_ratio(struct dir
>  	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
>  		long long wb_pos_ratio;
>  
> -		if (dtc->wb_dirty < 8) {
> -			dtc->pos_ratio = min_t(long long, pos_ratio * 2,
> -					   2 << RATELIMIT_CALC_SHIFT);
> -			return;
> -		}
> -
>  		if (dtc->wb_dirty >= wb_thresh)
>  			return;
>  
> @@ -1222,14 +1216,6 @@ static void wb_position_ratio(struct dir
>  	if (unlikely(wb_thresh > dtc->thresh))
>  		wb_thresh = dtc->thresh;
>  	/*
> -	 * It's very possible that wb_thresh is close to 0 not because the
> -	 * device is slow, but that it has remained inactive for long time.
> -	 * Honour such devices a reasonable good (hopefully IO efficient)
> -	 * threshold, so that the occasional writes won't be blocked and active
> -	 * writes can rampup the threshold quickly.
> -	 */
> -	wb_thresh = max(wb_thresh, (limit - dtc->dirty) / 8);
> -	/*
>  	 * scale global setpoint to wb's:
>  	 *	wb_setpoint = setpoint * wb_thresh / thresh
>  	 */
> @@ -1484,17 +1470,10 @@ static void wb_update_dirty_ratelimit(st
>  	 * balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate).
>  	 * Hence, to calculate "step" properly, we have to use wb_dirty as
>  	 * "dirty" and wb_setpoint as "setpoint".
> -	 *
> -	 * We rampup dirty_ratelimit forcibly if wb_dirty is low because
> -	 * it's possible that wb_thresh is close to zero due to inactivity
> -	 * of backing device.
>  	 */
>  	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
>  		dirty = dtc->wb_dirty;
> -		if (dtc->wb_dirty < 8)
> -			setpoint = dtc->wb_dirty + 1;
> -		else
> -			setpoint = (dtc->wb_thresh + dtc->wb_bg_thresh) / 2;
> +		setpoint = (dtc->wb_thresh + dtc->wb_bg_thresh) / 2;
>  	}
>  
>  	if (dirty < setpoint) {
> _
> 
> Patches currently in -mm which might be from jimzhao.ai@gmail.com are
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
