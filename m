Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE94722A80D
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 08:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744016265; cv=none; b=K5YOsP7thhUaYG0h56WCdx/AFFBKFEdFpL31ukpXoEBNZYZeOGOnYba8KDObyiGrc0D3X42+GrmKpnz2jR9Gok+l/mFV3UEcn7bABIJ1G72cphOsXOQf4EdmN6/QjrOLiesqnBFgY8HJGXxrVK/ReCu22Uj6CjV1wGXl9GV9Ic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744016265; c=relaxed/simple;
	bh=AJRgP/DtEEe6U3kZsOjp8vKBEUe/t2qyWWuB1hr/aFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOjJf7o9ZISC8+ey0C0fgsn3NWeeMk7WALUBMLQBXMkm/cQnYchyAJrdKxk23ZilJyVFXO10wDR+Fhj1sfFo09vSLdB8X2A/2VJkFfrpr58vE88tQ4hoFqzOA5nZrgwdbgM0QMA6ke/xHumlJ/Kp8UGbebKdzDrqCcnvuGUTNjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c9gInUqn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KLUx65QA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Eoi5zWaX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rYAQ/mHk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c9gInUqn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KLUx65QA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Eoi5zWaX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rYAQ/mHk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CAD2321160;
	Mon,  7 Apr 2025 08:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744016260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byzxzPwJCi9pruyrYE6IVyNHC/7kX70gXBbmiujd+IY=;
	b=c9gInUqnIttJ8w08T5r1pOK4T7ieFEu2odn7/+TFLgd0/YQ/RuCq5hdWRFoFVgzRjrkKpf
	r8/2QeBbhn/q+iL5j8WllpFbPE81Xi4nxZtKFAImIRqU9rICmZKAZzkLJEdvQnExmKPdj4
	JnNmiKZzOItJEESvBE5NLM8N0HraS7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744016260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byzxzPwJCi9pruyrYE6IVyNHC/7kX70gXBbmiujd+IY=;
	b=KLUx65QAkjD5cBfEQR3UWu+AXJaBq8CFvlIRLuHoquCJFnX0jiTwAIddGETq5GcHLg1JDm
	QTes0h/PNdGlVoCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Eoi5zWaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rYAQ/mHk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744016259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byzxzPwJCi9pruyrYE6IVyNHC/7kX70gXBbmiujd+IY=;
	b=Eoi5zWaXk+cuwaIDsKVGcY4K5F3hkUjBDFfK23fHqx2rCd2b4vhUcXTG9bcW/EvsTNY75w
	naGYp4/+hTHXVvOmdMQV4ziNzllU0YQLgmXxm/rC84j4nb53hQOmpOJG+qInw9Oq8tel3E
	UkWyP0Bp3jrt3Xj3NxXnxGgOlZfd+TI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744016259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byzxzPwJCi9pruyrYE6IVyNHC/7kX70gXBbmiujd+IY=;
	b=rYAQ/mHkKivmss8yoOqitTyIRLJrEEDOkO4jFCRvDWKIVgCqhoMpI7hwGACYcno7Y2c8J6
	atzezq2tyAITjKDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADBED13691;
	Mon,  7 Apr 2025 08:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cCAWKoOT82f9NwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 07 Apr 2025 08:57:39 +0000
Message-ID: <a6dd21b8-59e9-463b-a481-3ab2e9ef6dca@suse.cz>
Date: Mon, 7 Apr 2025 10:57:39 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + kunit-slub-add-module-description.patch added to
 mm-nonmm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, xiaopei01@kylinos.cn, sfr@canb.auug.org.au,
 rmoar@google.com, masahiroy@kernel.org, linux@roeck-us.net,
 jeff.johnson@oss.qualcomm.com, arnd@arndb.de
References: <20250407014823.7429FC4CEE3@smtp.kernel.org>
 <35d28527-50db-43ec-81e3-97b291941961@suse.cz>
 <20250407013732.9d4ac7ba2fd485af28c5461d@linux-foundation.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250407013732.9d4ac7ba2fd485af28c5461d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CAD2321160
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.cz:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 4/7/25 10:37, Andrew Morton wrote:
> On Mon, 7 Apr 2025 10:23:00 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> On 4/7/25 03:48, Andrew Morton wrote:
>> > The patch titled
>> >      Subject: kunit: slub: add module description
>> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>> >      kunit-slub-add-module-description.patch
>> > 
>> > This patch will shortly appear at
>> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-slub-add-module-description.patch
>> > 
>> > This patch will later appear in the mm-nonmm-unstable branch at
>> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> 
>> Hi,
>> 
>> since there's a new warning (initially even error) in rc1, could this and
>> other -add-module-descriptions.patch be moved to hotfixes?
> 
> Ok, but all we have is "Modules without a description now cause a
> warning".
> 
> Specifically which commit caused these warnings to start coming out?

I think 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
made it an error (previously W=1 warning)

6f110a5e4f99 ("Disable SLUB_TINY for build testing")
reduced it to warning (but not back to W=1)
