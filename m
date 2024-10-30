Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7530B1E0DD5;
	Wed, 30 Oct 2024 08:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730276505; cv=none; b=lkhUdmPteQvt1CO7IxSz8hRpVj/r5IA+TbdvO1Tsi45tKw0/uFbUw0zy2rO5hfJ6nXokhacNgHsDNcqEk9LfUoKNS3aAbiGlL1SQYUaaRXaVThaVaCKBPfJ/cZ/Bonu/CPglAQyu8T6a8VNO6S9NsVowW+eKWqDRxwHfc11tTNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730276505; c=relaxed/simple;
	bh=BKYX6p0yBT07lshM2EhOPNbdjlB/2GPjKhgUKn2AUMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cOOfBRTcg/iyusM4MX1U1BttdkyoE0gG7yUZ609oKXjQGw+e0Z3SIaLeipO2LYSvzywvYpI6qo4VWjiAiW38T8h+tFbcAfEQYp7ifqty+2kunbNpPclEMg4Ytmysb7Yqc2TLi+vYaoxodVDOMgN1yBD/PjanOZPxTqmjR0R8bDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yd4hyVaa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B9HSIgTj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yd4hyVaa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B9HSIgTj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yd4hyVaa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B9HSIgTj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yd4hyVaa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B9HSIgTj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EC121FDC9;
	Wed, 30 Oct 2024 08:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730276501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rd5UicMFfeThj0XTZ2oP5Hs2cVkhYs5tjsowhwtUqw0=;
	b=Yd4hyVaax5JepyZNMhibZrhzUw/5VH7ZVS02uHsJfo4FWk1ZEyHvvaDiKZZ1/lbHKJr+9i
	krddh9k6mFj/LlUqYAmjyraTMETJ8mzRFr3FlwO0bd3sZRtGyrmdRIzrvzZ4HWokqzx1pt
	2qDQ+n8ZC5ziF5YLefnxtOQL3VRSYeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730276501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rd5UicMFfeThj0XTZ2oP5Hs2cVkhYs5tjsowhwtUqw0=;
	b=B9HSIgTjRqOkX2cGm8n4WkGZIH55m9682GFYrJBkJWS0rQLs40EEkLweKby3L9+E7pX8hH
	eyorV37Q9xVg9iDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yd4hyVaa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B9HSIgTj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730276501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rd5UicMFfeThj0XTZ2oP5Hs2cVkhYs5tjsowhwtUqw0=;
	b=Yd4hyVaax5JepyZNMhibZrhzUw/5VH7ZVS02uHsJfo4FWk1ZEyHvvaDiKZZ1/lbHKJr+9i
	krddh9k6mFj/LlUqYAmjyraTMETJ8mzRFr3FlwO0bd3sZRtGyrmdRIzrvzZ4HWokqzx1pt
	2qDQ+n8ZC5ziF5YLefnxtOQL3VRSYeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730276501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rd5UicMFfeThj0XTZ2oP5Hs2cVkhYs5tjsowhwtUqw0=;
	b=B9HSIgTjRqOkX2cGm8n4WkGZIH55m9682GFYrJBkJWS0rQLs40EEkLweKby3L9+E7pX8hH
	eyorV37Q9xVg9iDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53554136A5;
	Wed, 30 Oct 2024 08:21:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6ULNE5XsIWf0DwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 30 Oct 2024 08:21:41 +0000
Message-ID: <0d0ddb33-fcdc-43e2-801f-0c1df2031afb@suse.cz>
Date: Wed, 30 Oct 2024 09:21:41 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-page_alloc-keep-track-of-free-highatomic.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com,
 linkl@google.com, yuzhao@google.com
References: <20241029005805.9BEF2C4CEC3@smtp.kernel.org>
 <cbbad18f-80ad-4283-b437-65f86411f803@suse.cz>
 <20241029123046.b81890f3c5fa181d667cc4d4@linux-foundation.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20241029123046.b81890f3c5fa181d667cc4d4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6EC121FDC9
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.cz:mid];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 10/29/24 20:30, Andrew Morton wrote:
> On Tue, 29 Oct 2024 10:05:43 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> On 10/29/24 01:58, Andrew Morton wrote:
>> > The patch titled
>> >      Subject: mm/page_alloc: keep track of free highatomic
>> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>> >      mm-page_alloc-keep-track-of-free-highatomic.patch
>> 
>> In case of mm-hotfixes, the cc stable for 6.12 is unnecessary as it should
>> make it there directly. Perhaps it's the best way, yeah.
> 
> Oh, yeah, right.  There's no Fixes:.  How do we know it's 6.12+?

Fixes: 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order
atomic allocations on demand")
Depends-on: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")

We've discussed [1] how this is not a good stable material due to the
dependency from 6.10 and the problem is old and nobody has reported it yet,
and also doesn't meet the stable kernel rules. But targetting 6.12 (which
currently happens via the hotfixes branch) would make sense because it's
most likely the next LTS and already has the dependency.

So with the tags above we're not proposing it for stable backports
ourselves, but anyone who considers to backport it should have sufficient
information.

[1] https://lore.kernel.org/all/afd9f99f-f49a-41c7-b987-9e59a9d296ad@suse.cz/
