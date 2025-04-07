Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35BC227EBB
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 08:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014184; cv=none; b=s7nGpOZo3e1mXWEgGLF37mNtcXgYPIMm3IdV3NBYZfTObyGEwddIwGQN/67x8jHoXXKOPatzASaYzlj9s+eBID10gD5zsfB3pFeJCB6Bo5l2CLBc6pfXQ8FHcNBVLNwCf0TdLZm5ZPtGIstMbIuZGwqxTHOc5W+beqp0E2p3SVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014184; c=relaxed/simple;
	bh=uiS+uFcOWbZsHeUqIJaDjTR6S5khK2958XICMeRSKkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BbzVQZWWjzU7ttR1t5P/5Jz2oloBRv8XxxLaBsIjzgkVtDgaFcqNOh1EXEOiGyZ6IG/UGWJc4Yvp4eWCSfHwAVJfAAtK5iyraJ/MZ3MJyW8qKPaGqtsXlVn6Xaa3Qbc/cYDwg6OdhxHoLhD02S/aUH8PU2QhZ5FTgMMogYSwEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vPBanv/S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zuhl3LtT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pf30q4qj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nRXNPLNT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vPBanv/S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zuhl3LtT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pf30q4qj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nRXNPLNT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E31B721172;
	Mon,  7 Apr 2025 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744014181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnXO9J9EDIv9PXdKH9fv/h6MKAeDvdaEwfh+rmyWauY=;
	b=vPBanv/SemkR/4Z+b5Tj1mnVn7IhBHkcuxty/wXabl9eD7M6to6QGFKBOLV09F9V8H13Vj
	5UdeMqSbuIjY7giz74MVq1nL1NYT2bsZltCJMZHt7BrnUAFsZo0pTzgR7vUqBk3WtQZ+EW
	ICMXcDYBNVm3lmBHsJwPZFhkDC4Y0Rk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744014181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnXO9J9EDIv9PXdKH9fv/h6MKAeDvdaEwfh+rmyWauY=;
	b=zuhl3LtTF9CNjwxFpvhtVK2EMn6zCh2zWH+umTtZIr+88lDoVEUPSEu/zzUYQc51u1SA+/
	2Zr/M84C1EsJ1CBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744014180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnXO9J9EDIv9PXdKH9fv/h6MKAeDvdaEwfh+rmyWauY=;
	b=Pf30q4qjCSHpPtuL3PsbpLmxtOML9smFn9uZNFu4KzO/0NuV2qy+alnDL037FCNtdnpylC
	rgtajauEWpXCDc5O4CPwzOoOiIlrNbH+TUPYlbftvK6QxJIXdIoyIFYsQRz4AxExcym69b
	EYLDBkH0niJK4CBBqUTaaLfDiYhYxGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744014180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnXO9J9EDIv9PXdKH9fv/h6MKAeDvdaEwfh+rmyWauY=;
	b=nRXNPLNTYUP1mycLuB5CVbxj0PC9RTwwG1akFnoPp5x71p14afVO75YVxAlGi0UmwA2CZs
	DascxfxxU6QsQCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3FDD13691;
	Mon,  7 Apr 2025 08:23:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sHd/L2SL82d1KwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 07 Apr 2025 08:23:00 +0000
Message-ID: <35d28527-50db-43ec-81e3-97b291941961@suse.cz>
Date: Mon, 7 Apr 2025 10:23:00 +0200
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
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 xiaopei01@kylinos.cn, sfr@canb.auug.org.au, rmoar@google.com,
 masahiroy@kernel.org, linux@roeck-us.net, jeff.johnson@oss.qualcomm.com,
 arnd@arndb.de
References: <20250407014823.7429FC4CEE3@smtp.kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250407014823.7429FC4CEE3@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 4/7/25 03:48, Andrew Morton wrote:
> The patch titled
>      Subject: kunit: slub: add module description
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kunit-slub-add-module-description.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-slub-add-module-description.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Hi,

since there's a new warning (initially even error) in rc1, could this and
other -add-module-descriptions.patch be moved to hotfixes?

Thanks,
Vlastimil

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
> From: Arnd Bergmann <arnd@arndb.de>
> Subject: kunit: slub: add module description
> Date: Mon, 24 Mar 2025 18:32:35 +0100
> 
> Modules without a description now cause a warning:
> 
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/tests/slub_kunit.o
> 
> Link: https://lkml.kernel.org/r/20250324173242.1501003-10-arnd@kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Guenetr Roeck <linux@roeck-us.net>
> Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Pei Xiao <xiaopei01@kylinos.cn>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Stehen Rothwell <sfr@canb.auug.org.au>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/tests/slub_kunit.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/lib/tests/slub_kunit.c~kunit-slub-add-module-description
> +++ a/lib/tests/slub_kunit.c
> @@ -325,4 +325,5 @@ static struct kunit_suite test_suite = {
>  };
>  kunit_test_suite(test_suite);
>  
> +MODULE_DESCRIPTION("Kunit tests for slub allocator");
>  MODULE_LICENSE("GPL");
> _
> 
> Patches currently in -mm which might be from arnd@arndb.de are
> 
> exportfs-add-module-description.patch
> asn1-add-module-description.patch
> samples-livepatch-add-module-descriptions.patch
> fpga-tests-add-module-descriptions.patch
> xenbus-add-module-description.patch
> zlib-add-module-description.patch
> ucs2_string-add-module-description.patch
> mm-kasan-add-module-decription.patch
> kunit-slub-add-module-description.patch
> 

