Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C266101CE
	for <mm-commits@vger.kernel.org>; Sat, 18 May 2024 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716066243; cv=none; b=twMij4RZiDfsH3uvQFnfQWrsO1IPAQjSxCTJjz4tKanpp9xtHF5beml+ojCKUcANIsUnKC+jC4ubP3pTVmTw2bzTcAaFBRh7aFIO2dDryqHAoy6n2yaPsIAG943rwUod+PoV8p+Pjues/lYajaPBb6b5+WJpa0+XV53dxPX1JJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716066243; c=relaxed/simple;
	bh=vgxfmrpRW4I/OQSyhmil1AkNOGNXMQPIGMT4vQqkO/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bkZwOi44fdNwS0FWj6J7lvApOID/3iFe7nKeEMIDgrBNuupLRw2ppm/b93wMl2VYHx2JIkeN1RcO24unDrJXfYGN8irNsPKpwXUd+pRp2cjU06r5Lcwl75GNrou9lvfIwSNj/M4m/8loimU44QZBaof4qzbuHq2Pf/Olf5mGYN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3IEeNbw7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oN3uzuJT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3IEeNbw7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oN3uzuJT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3IEeNbw7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oN3uzuJT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3IEeNbw7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oN3uzuJT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91B071FB71;
	Sat, 18 May 2024 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716066232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aMSdpzYGAI74pllO7DpF/xThonHpXkJenigF58TBdXg=;
	b=3IEeNbw72NMbx2jSrdOzqirby0z1Om5O+QBa3hy7Nh82Dt2q6TKc9SAiqHC1VDdKw4W+BR
	wKm2sWEjWjDOacfbLvzQonNUYqI7ckIZfgWzf9fLS1X7YsfcltPfwNtnulAr1AZH949PSw
	kQ7S+OSZuDX6TYflQexgXowqnovtM6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716066232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aMSdpzYGAI74pllO7DpF/xThonHpXkJenigF58TBdXg=;
	b=oN3uzuJTS4IijSVEk/cY4Ee1UPLNHn5BqCEl3OJPDNcWDR7Kt8fPdgpxwV5BXlV2HTQkj5
	9d6tV0xF1h8KV+Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3IEeNbw7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oN3uzuJT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716066232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aMSdpzYGAI74pllO7DpF/xThonHpXkJenigF58TBdXg=;
	b=3IEeNbw72NMbx2jSrdOzqirby0z1Om5O+QBa3hy7Nh82Dt2q6TKc9SAiqHC1VDdKw4W+BR
	wKm2sWEjWjDOacfbLvzQonNUYqI7ckIZfgWzf9fLS1X7YsfcltPfwNtnulAr1AZH949PSw
	kQ7S+OSZuDX6TYflQexgXowqnovtM6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716066232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aMSdpzYGAI74pllO7DpF/xThonHpXkJenigF58TBdXg=;
	b=oN3uzuJTS4IijSVEk/cY4Ee1UPLNHn5BqCEl3OJPDNcWDR7Kt8fPdgpxwV5BXlV2HTQkj5
	9d6tV0xF1h8KV+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72E09134C3;
	Sat, 18 May 2024 21:03:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9IJlG7gXSWZrSAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 18 May 2024 21:03:52 +0000
Message-ID: <5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>
Date: Sat, 18 May 2024 23:03:52 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + lib-add-version-into-proc-allocinfo-output.patch added to
 mm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 pasha.tatashin@soleen.com, kent.overstreet@linux.dev, keescook@chromium.org,
 surenb@google.com
References: <20240514202009.2FA52C2BD10@smtp.kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240514202009.2FA52C2BD10@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 91B071FB71
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 5/14/24 10:20 PM, Andrew Morton wrote:
> The patch titled
>      Subject: lib: add version into /proc/allocinfo output
> has been added to the -mm mm-unstable branch.  Its filename is

Hi, I don't know how mm-unstable/mm-hotfixes-unstable is handled during and
right after the merge window, so maybe it's already the plan, but wanted to
note that for this patch to set the userspace ABI with versioning right
away, it should go in before 5.10 is released, and maybe even in the merge
window itself so the version line is already there at 5.10-rc1.

Thanks,
Vlastimil

Also:
Acked-by: Vlastimil Babka <vbabka@suse.cz>

>      lib-add-version-into-proc-allocinfo-output.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-version-into-proc-allocinfo-output.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: lib: add version into /proc/allocinfo output
> Date: Tue, 14 May 2024 09:31:28 -0700
> 
> Add version string and a header at the beginning of /proc/allocinfo to
> allow later format changes.  Example output:
> 
>> head /proc/allocinfo
> allocinfo - version: 1.0
> #     <size>  <calls> <tag info>
>            0        0 init/main.c:1314 func:do_initcalls
>            0        0 init/do_mounts.c:353 func:mount_nodev_root
>            0        0 init/do_mounts.c:187 func:mount_root_generic
>            0        0 init/do_mounts.c:158 func:do_mount_root
>            0        0 init/initramfs.c:493 func:unpack_to_rootfs
>            0        0 init/initramfs.c:492 func:unpack_to_rootfs
>            0        0 init/initramfs.c:491 func:unpack_to_rootfs
>          512        1 arch/x86/events/rapl.c:681 func:init_rapl_pmus
>          128        1 arch/x86/events/rapl.c:571 func:rapl_cpu_online
> 
> Link: https://lkml.kernel.org/r/20240514163128.3662251-1-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/filesystems/proc.rst |    5 +-
>  lib/alloc_tag.c                    |   48 ++++++++++++++++++---------
>  2 files changed, 36 insertions(+), 17 deletions(-)
> 
> --- a/Documentation/filesystems/proc.rst~lib-add-version-into-proc-allocinfo-output
> +++ a/Documentation/filesystems/proc.rst
> @@ -961,13 +961,14 @@ Provides information about memory alloca
>  base. Each allocation in the code is identified by its source file, line
>  number, module (if originates from a loadable module) and the function calling
>  the allocation. The number of bytes allocated and number of calls at each
> -location are reported.
> +location are reported. The first line indicates the version of the file, the
> +second line is the header listing fields in the file.
>  
>  Example output.
>  
>  ::
>  
> -    > sort -rn /proc/allocinfo
> +    > tail -n +3 /proc/allocinfo | sort -rn
>     127664128    31168 mm/page_ext.c:270 func:alloc_page_ext
>      56373248     4737 mm/slub.c:2259 func:alloc_slab_page
>      14880768     3633 mm/readahead.c:247 func:page_cache_ra_unbounded
> --- a/lib/alloc_tag.c~lib-add-version-into-proc-allocinfo-output
> +++ a/lib/alloc_tag.c
> @@ -16,47 +16,61 @@ EXPORT_SYMBOL(_shared_alloc_tag);
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>  			mem_alloc_profiling_key);
>  
> +struct allocinfo_private {
> +	struct codetag_iterator iter;
> +	bool print_header;
> +
> +};
> +
>  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>  {
> -	struct codetag_iterator *iter;
> +	struct allocinfo_private *priv;
>  	struct codetag *ct;
>  	loff_t node = *pos;
>  
> -	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> -	m->private = iter;
> -	if (!iter)
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	m->private = priv;
> +	if (!priv)
>  		return NULL;
>  
> +	priv->print_header = (node == 0);
>  	codetag_lock_module_list(alloc_tag_cttype, true);
> -	*iter = codetag_get_ct_iter(alloc_tag_cttype);
> -	while ((ct = codetag_next_ct(iter)) != NULL && node)
> +	priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
> +	while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
>  		node--;
>  
> -	return ct ? iter : NULL;
> +	return ct ? priv : NULL;
>  }
>  
>  static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
>  {
> -	struct codetag_iterator *iter = (struct codetag_iterator *)arg;
> -	struct codetag *ct = codetag_next_ct(iter);
> +	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
> +	struct codetag *ct = codetag_next_ct(&priv->iter);
>  
>  	(*pos)++;
>  	if (!ct)
>  		return NULL;
>  
> -	return iter;
> +	return priv;
>  }
>  
>  static void allocinfo_stop(struct seq_file *m, void *arg)
>  {
> -	struct codetag_iterator *iter = (struct codetag_iterator *)m->private;
> +	struct allocinfo_private *priv = (struct allocinfo_private *)m->private;
>  
> -	if (iter) {
> +	if (priv) {
>  		codetag_lock_module_list(alloc_tag_cttype, false);
> -		kfree(iter);
> +		kfree(priv);
>  	}
>  }
>  
> +static void print_allocinfo_header(struct seq_buf *buf)
> +{
> +	/* Output format version, so we can change it. */
> +	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
> +	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> +}
> +
>  static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
>  {
>  	struct alloc_tag *tag = ct_to_alloc_tag(ct);
> @@ -71,13 +85,17 @@ static void alloc_tag_to_text(struct seq
>  
>  static int allocinfo_show(struct seq_file *m, void *arg)
>  {
> -	struct codetag_iterator *iter = (struct codetag_iterator *)arg;
> +	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
>  	char *bufp;
>  	size_t n = seq_get_buf(m, &bufp);
>  	struct seq_buf buf;
>  
>  	seq_buf_init(&buf, bufp, n);
> -	alloc_tag_to_text(&buf, iter->ct);
> +	if (priv->print_header) {
> +		print_allocinfo_header(&buf);
> +		priv->print_header = false;
> +	}
> +	alloc_tag_to_text(&buf, priv->iter.ct);
>  	seq_commit(m, seq_buf_used(&buf));
>  	return 0;
>  }
> _
> 
> Patches currently in -mm which might be from surenb@google.com are
> 
> lib-add-version-into-proc-allocinfo-output.patch
> 

