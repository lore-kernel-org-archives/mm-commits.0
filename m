Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF4C2FDC30
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 22:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769465082; cv=none; b=IYj5/ujnMNB1HISR//F6ds68RdI+z+89Bg68kfKdL2DCUoWePF3+bVYwiURBRP6PCQZpbzJwPBleCrY0C7yAcvz5WsMlsIwOrEOgrylRES0gjGXiRFvkrazU4JWRiZb/QM/O7uG1rAsQkGuj1W0k+fKmqHKRdSZ11zuEWLj5oY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769465082; c=relaxed/simple;
	bh=ed8Xjz5Uk+wMXZ2UanfcVD38k3gvd6Rn+URSRNH/hgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oTx1Ug2+QBiM8XKTNRoHhOCA0YawGWuojXc8mTi+wQrJgeeUc275Ut2URIZG6Xy5iIhJ6evgc197ThKR8slQHeUxSeZmTr1XfxlklJaYj0m3t4a9aciysbrUorz5kBq87pinX3CL+MjLT/4ee1Z8+uv4bFzaLyDIP4K/v7zvsbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jR0OXGUn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HkJ+m1PV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jR0OXGUn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HkJ+m1PV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jR0OXGUn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HkJ+m1PV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jR0OXGUn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HkJ+m1PV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22D1F5BCDB;
	Mon, 26 Jan 2026 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769465078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+cFO41MzImUyyJiBXueWHEJ/MkFPvuzgcKp3yoWaD9s=;
	b=jR0OXGUn0aw9GB1GJUbOZPaRrRyNG9khIdSxw6q4qJe9iXKjqgInskb9W7t5G6Znjpavt4
	C8S/dGPiW39YUaAuTJ9uPB579Bx6UTjObcqVSXKeyLqGrA/32zuh0926N4QBQbzw0J+JtA
	+o4LX/r3V3kLhekaCCh1+ctayoP3w1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769465078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+cFO41MzImUyyJiBXueWHEJ/MkFPvuzgcKp3yoWaD9s=;
	b=HkJ+m1PV0U/b3SGxCHYyOFoi7Rj2mndhIHSRXTkPoyL25U7PL99JED2RghHhYLC5BRu0Qj
	R6GJrtWqXc4T2ECQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jR0OXGUn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HkJ+m1PV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769465078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+cFO41MzImUyyJiBXueWHEJ/MkFPvuzgcKp3yoWaD9s=;
	b=jR0OXGUn0aw9GB1GJUbOZPaRrRyNG9khIdSxw6q4qJe9iXKjqgInskb9W7t5G6Znjpavt4
	C8S/dGPiW39YUaAuTJ9uPB579Bx6UTjObcqVSXKeyLqGrA/32zuh0926N4QBQbzw0J+JtA
	+o4LX/r3V3kLhekaCCh1+ctayoP3w1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769465078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+cFO41MzImUyyJiBXueWHEJ/MkFPvuzgcKp3yoWaD9s=;
	b=HkJ+m1PV0U/b3SGxCHYyOFoi7Rj2mndhIHSRXTkPoyL25U7PL99JED2RghHhYLC5BRu0Qj
	R6GJrtWqXc4T2ECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 035EF139F0;
	Mon, 26 Jan 2026 22:04:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 79t+APbkd2nTYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 22:04:38 +0000
Message-ID: <09e89c13-98c7-42c9-888a-b80ffd42dbbf@suse.cz>
Date: Mon, 26 Jan 2026 23:04:37 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch added
 to mm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 surenb@google.com, shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com,
 longman@redhat.com, liam.howlett@oracle.com, boqun.feng@gmail.com,
 lorenzo.stoakes@oracle.com
References: <20260126183033.9AF69C19421@smtp.kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260126183033.9AF69C19421@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[linux-foundation.org,vger.kernel.org,google.com,linux.dev,kernel.org,suse.com,redhat.com,oracle.com,gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 22D1F5BCDB
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On 1/26/26 19:30, Andrew Morton wrote:
> The patch titled
>      Subject: mm-vma-update-vma_assert_locked-to-use-lockdep-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Subject: mm-vma-update-vma_assert_locked-to-use-lockdep-fix
> Date: Mon, 26 Jan 2026 16:40:34 +0000
> 
> add helper macro __vma_lockdep_map(), per Vlastimil

Note I didn't suggest this part :) But LGTM. And the above will be squashed
away anyway.

> Link: https://lkml.kernel.org/r/7c4b722e-604b-4b20-8e33-03d2f8d55407@lucifer.local
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Waiman Long <longman@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/mmap_lock.h |   29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> --- a/include/linux/mmap_lock.h~mm-vma-update-vma_assert_locked-to-use-lockdep-fix
> +++ a/include/linux/mmap_lock.h
> @@ -78,6 +78,12 @@ static inline void mmap_assert_write_loc
>  
>  #ifdef CONFIG_PER_VMA_LOCK
>  
> +#ifdef CONFIG_LOCKDEP
> +#define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
> +#else
> +#define __vma_lockdep_map(vma) NULL
> +#endif
> +
>  /*
>   * VMA locks do not behave like most ordinary locks found in the kernel, so we
>   * cannot quite have full lockdep tracking in the way we would ideally prefer.
> @@ -98,16 +104,16 @@ static inline void mmap_assert_write_loc
>   * so we utilise lockdep to do so.
>   */
>  #define __vma_lockdep_acquire_read(vma) \
> -	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
> +	lock_acquire_shared(__vma_lockdep_map(vma), 0, 1, NULL, _RET_IP_)
>  #define __vma_lockdep_release_read(vma) \
> -	lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +	lock_release(__vma_lockdep_map(vma), _RET_IP_)
>  #define __vma_lockdep_acquire_exclusive(vma) \
> -	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
> +	lock_acquire_exclusive(__vma_lockdep_map(vma), 0, 0, NULL, _RET_IP_)
>  #define __vma_lockdep_release_exclusive(vma) \
> -	lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +	lock_release(__vma_lockdep_map(vma), _RET_IP_)
>  /* Only meaningful if CONFIG_LOCK_STAT is defined. */
>  #define __vma_lockdep_stat_mark_acquired(vma) \
> -	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> +	lock_acquired(__vma_lockdep_map(vma), _RET_IP_)
>  
>  static inline void mm_lock_seqcount_init(struct mm_struct *mm)
>  {
> @@ -146,7 +152,7 @@ static inline void vma_lock_init(struct
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	static struct lock_class_key lockdep_key;
>  
> -	lockdep_init_map(&vma->vmlock_dep_map, "vm_lock", &lockdep_key, 0);
> +	lockdep_init_map(__vma_lockdep_map(vma), "vm_lock", &lockdep_key, 0);
>  #endif
>  	if (reset_refcnt)
>  		refcount_set(&vma->vm_refcnt, 0);
> @@ -340,14 +346,11 @@ static inline void vma_assert_locked(str
>  {
>  	unsigned int refcnt;
>  
> -	/*
> -	 * If read-locked or currently excluding readers, then the VMA is
> -	 * locked.
> -	 */
> -#ifdef CONFIG_LOCKDEP
> -	if (lock_is_held(&vma->vmlock_dep_map))
> +	if (IS_ENABLED(CONFIG_LOCKDEP)) {
> +		if (!lock_is_held(__vma_lockdep_map(vma)))
> +			vma_assert_write_locked(vma);
>  		return;
> -#endif
> +	}
>  
>  	/*
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
> _
> 
> Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are
> 
> mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
> mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
> mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
> mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
> mm-rmap-remove-anon_vma_merge-function.patch
> mm-rmap-make-anon_vma-functions-internal.patch
> mm-mmap_lock-add-vma_is_attached-helper.patch
> mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
> mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
> selftests-mm-remove-virtual_address_range-test.patch
> mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
> mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
> mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
> mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
> mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
> mm-vma-clean-up-__vma_enter-exit_locked.patch
> mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
> mm-vma-improve-and-document-__is_vma_write_locked.patch
> mm-vma-update-vma_assert_locked-to-use-lockdep.patch
> mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
> mm-vma-add-and-use-vma_assert_stabilised.patch
> mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
> mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
> mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
> tools-bitmap-add-missing-bitmap_.patch
> mm-add-basic-vma-flag-operation-helper-functions.patch
> mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
> mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
> mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
> mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
> mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
> tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
> tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
> tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch
> 

