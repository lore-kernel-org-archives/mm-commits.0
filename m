Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD1B2F290E
	for <mm-commits@vger.kernel.org>; Fri, 12 Dec 2025 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765562000; cv=none; b=Gq94oYZel3Q6gAOuIpur2xi4qH+S7oGwgq0cbTgZbBczW/DQarZwEBnat34jdbMlqMV17JKkO3jqC9gIpmGHXLF3fxOVgJ95R+0a6tyTbghvIaWmWtBZOh/fy5J6O3xdH2YnBwrQXMqSTNrU8RrEbgeFgdz4BQ+BfUPX91YyEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765562000; c=relaxed/simple;
	bh=CFc3hMg0tUCqyL29xBAWXE9CuHj2iJ3j1f6ugP/KDx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epRdyRQqJxoDSZyJKi6ta5N8eUjd3/SMw+KNFqkqtOeaIBvxdi7ASnCl/2PX8TMs4flCuaHysVn83a7Y8g2EgRaxd/TnL5Mspn55VcDWr/3MNmnNDp9sLjvsYavI7t286GAg6E631gsizgnF+/c4ofUrMB2jj8rCeMEB8qEqVMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xg4nvBRT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u01j0//i; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v2HGz5PE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lUyx3aII; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xg4nvBRT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u01j0//i";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v2HGz5PE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lUyx3aII"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 458C55BD68;
	Fri, 12 Dec 2025 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765561997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rigPxaMOGm0Gprk6dhDTPDXoavmx8V01/fMDcFDFUFk=;
	b=xg4nvBRTbpOP2+XesbSAzbAO+OM+xlJhLNOo94u1aWPnBXm4fr4wpe/N5MmJ0Nz0DTSTFI
	B8NR6YPJgYtmc5+4HqQhVShqlMBFjBxWs/gssMDx0i5DqqzK4F3O+EMmlX2wroXPZrClDK
	6dVQ+voXGfwT36ei2woU0CIX8+VBw0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765561997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rigPxaMOGm0Gprk6dhDTPDXoavmx8V01/fMDcFDFUFk=;
	b=u01j0//iSX873Ztk0Re6SP5PxA/pRXu0mThZK5y61uczV9mwj/TE8qwBONkRu5Bs49b5u+
	j205J0xjpCgnRNAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765561996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rigPxaMOGm0Gprk6dhDTPDXoavmx8V01/fMDcFDFUFk=;
	b=v2HGz5PEMekUHTMirvAMrZoAcQule8jpLKeH52HUhwDYyHY4LJ45166QwXoISUsbNAzewG
	KQXU6ii9DO6PgmXGTuOo8e5MQlTLujgvVwyDdEE8WN2/ro81KaM1iYMSjBbVvNJAQKK4dj
	WWKZbQIEKSypf7y5QC3z7BXrHfvF2sA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765561996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rigPxaMOGm0Gprk6dhDTPDXoavmx8V01/fMDcFDFUFk=;
	b=lUyx3aIIhyo5LE+vjB+u/rMb+qTf+PvsOeTVZHsXZjC6XQVGBw9z5kaOP+lWGOjXvXJ33z
	rAers0Mi5NdtctCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C0283EA63;
	Fri, 12 Dec 2025 17:53:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mpprCoxWPGlWfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Dec 2025 17:53:16 +0000
Message-ID: <b7e9188d-d59a-494e-9568-ea7031baa450@suse.cz>
Date: Fri, 12 Dec 2025 18:53:15 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
 oliver.sang@intel.com, mhocko@suse.com, liam.howlett@oracle.com,
 jhubbard@nvidia.com, david.laight.linux@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
 <95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
 <20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
 <20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
 <5a479ed5-3cce-42fc-a572-771244108dee@lucifer.local>
 <20251210094642.113c6cc9006ffe4da771f6b0@linux-foundation.org>
 <33122d25-9451-47aa-b4ea-a0ba22305bff@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <33122d25-9451-47aa-b4ea-a0ba22305bff@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,kernel.org,intel.com,suse.com,oracle.com,nvidia.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]

On 12/12/25 18:46, Lorenzo Stoakes wrote:
> On Wed, Dec 10, 2025 at 09:46:42AM -0800, Andrew Morton wrote:
>> On Wed, 10 Dec 2025 09:36:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>>
>> > >
>> > > So I'm holding it in want-and-see mode - we can add it later as a
>> > > hotfix.
>> >
>> > I mean not sure it's really worth holding back given this is:
>> >
>> > BIT(...) vs.
>> >
>> > (1UL << ...)
>> >
>> > Hardly something that is hugely harmful no?
>>
>> Nope.  I'm just giving it some settling time.  Doing it as a hotfix in
>> a week or so is fine.
>>
> 
> Actually, given we've prety much confirmed this is random, unrelated behaviour,
> I don't think we need this patch after all.

Agreed. Let's drop it.

Thanks, Vlastimil

