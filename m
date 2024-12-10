Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FCD1A9B3F
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733840449; cv=none; b=idmasewiz9QwmIPvYeczIPz39GZg98gJtODstviXKrL9ybSVSpn3Sb3emZoWUC0djd/xnTiYpMoTaPMCodqLnDd2Y/so2TxXnDHSPZtzK7fyIp9p4zdL5SFhtqllFrUijZrQUgyB11ShVhiHckbHLXkp8QK5XVLoju51V06RENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733840449; c=relaxed/simple;
	bh=DDHDKGaVlu0x3hSSN7K6WOsUJxpndZq75f4pFbf/1jw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TkL1X58k3g1dHbWNfeRRHtzZFvM4LzN+QOh9DyHdk9xDDipVRTDw44+WiN8PtNaH+B6VWD47R0vicFVIWRuPRULYwLsLDQZErhIaYSWhOF8yN1oJo8hGTpQ9zxN813u5HSl98DeCKvTQqUgmwZoy3BJZO8WdwuIeIx0ERpsAqko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YZ8vRngu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8EyQHvDb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pt9b1STv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZWmFWKEa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YZ8vRngu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8EyQHvDb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pt9b1STv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZWmFWKEa"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CD57E1F441;
	Tue, 10 Dec 2024 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733840446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQ94tzb0CSFYvNMCK7pwnRAGANwL6HNBAIRGgfkpISU=;
	b=YZ8vRnguQae2hdZjjHBudXCYmwlPvBeu0uGJ+DAjsKEeU9I80hEu2/R0Cl9YxRN756ZZXI
	V+9GbYI7GtADKTnWravsOaDMgoQGzkv9aDtx6z1NJLSKsLqc6RdvpcFEbsIf6CdenhYbur
	1ZAArJjKDcvFEW1lfr+GBcXJofCVdPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733840446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQ94tzb0CSFYvNMCK7pwnRAGANwL6HNBAIRGgfkpISU=;
	b=8EyQHvDbW31LUzPE0oVA9CDVnbqKtwwHXkHQzw+uqMK+gC/HHIYRoxoLVdf3P1CfDGHTkz
	iEmXtRrleNwWljAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pt9b1STv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZWmFWKEa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733840445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQ94tzb0CSFYvNMCK7pwnRAGANwL6HNBAIRGgfkpISU=;
	b=pt9b1STvbe2fyQZbLiPdMCY2BtHa2NGuUrYP2v8A5sIW60zZT1BxPtYwp4FqGvt0kY9PT7
	QCi+S/06EtN+FK4BCuiEOScjqBOuPkEglo1mCzmtbhLm3WC9JKqLmzAwJwD8inu7JwemS+
	no8alUd2mM7twnc1jVT8+WuK5wzm5UU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733840445;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQ94tzb0CSFYvNMCK7pwnRAGANwL6HNBAIRGgfkpISU=;
	b=ZWmFWKEaEvE5zxB+liM3OMO8uq8rzEiWwUVW1JBUtuYTlZCaH/q9IIeRMlfdyZB/UTsSgD
	UUGZiOLmhhEvOjCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1B1413A15;
	Tue, 10 Dec 2024 14:20:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OtXkLj1OWGfbEgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 10 Dec 2024 14:20:45 +0000
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Dec 2024 15:20:45 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
 david@redhat.com
Subject: Re: +
 mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
 added to mm-unstable branch
In-Reply-To: <20241210014750.875ECC4CED1@smtp.kernel.org>
References: <20241210014750.875ECC4CED1@smtp.kernel.org>
User-Agent: Roundcube Webmail
Message-ID: <f8cb84978e9067ad14b248eb46d94de4@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CD57E1F441
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,nvidia.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 2024-12-10 02:47, Andrew Morton wrote:
> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: mm/memory_hotplug: don't use __GFP_HARDWALL when migrating
> pages via memory offlining
> Date: Thu, 5 Dec 2024 10:05:08 +0100
> 
> We'll migrate pages allocated by other context; respecting the cpuset 
> of
> the memory offlining context when allocating a migration target does 
> not
> make sense.
> 
> Drop the __GFP_HARDWALL by using GFP_KERNEL.
> 
> Note that in an ideal world, migration code could figure out the cpuset
> of the original context and take that into consideration.
> 
> Link: 
> https://lkml.kernel.org/r/20241205090508.2095225-3-david@redhat.com
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I would swear I acked this upstream:

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
> 
>  mm/memory_hotplug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> ---
> a/mm/memory_hotplug.c~mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining
> +++ a/mm/memory_hotplug.c
> @@ -1838,7 +1838,7 @@ put_folio:
>  		nodemask_t nmask = node_states[N_MEMORY];
>  		struct migration_target_control mtc = {
>  			.nmask = &nmask,
> -			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
> +			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
>  			.reason = MR_MEMORY_HOTPLUG,
>  		};
>  		int ret;
> _
> 
> Patches currently in -mm which might be from david@redhat.com are
> 
> docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
> mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
> mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
> mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
> mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
> mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
> mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
> powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
> mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
> fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
> fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
> fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
> fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
> fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
> fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
> fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
> fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
> virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
> virtio-mem-remember-usable-region-size.patch
> virtio-mem-support-config_proc_vmcore_device_ram.patch
> s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch
> mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch
> mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch
> mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
> mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

-- 
Oscar Salvador
SUSE Labs
