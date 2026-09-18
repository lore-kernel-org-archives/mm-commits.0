Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F24DE72D;
	Fri, 18 Sep 2026 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731650; cv=none; b=GrT0n1Soo8MlDdjfq+c/dYRHMJdMFWmIcv7URAslcz7vNdygT+heq2ODZ5GiNnfgkX07KXYlN0u57CaCSLR11K0tdg+FH8SS9miTHHwEakvPOnB83koHbedxPQsl1yU4tBJ5R1d3EvluM7vubAN1xmsios7NS6jf1Yl20nNn6TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731650; c=relaxed/simple;
	bh=XpSuwGZnYFjTU+paGpF2MRT0yG1kBXF9q/zGQRU036k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/1VSOjW5kE89sV5nHlSq1rfdiKplSAq28pKdIgrJA06E5JjDnFj+Gp2T8IpzqHInlPbT2oQtcX9MastNYz++HtmZw/kENkDaB7mZ4IRWXA81kKCjInCFQ0N9Hfo7ht5rF/cjD1T9PPHZqpFV+glHZHtfqJWrXC0E9hRPxphE0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V+JDyT0T; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cbDcJDVI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j+ufSfDG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=40lN+QXO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V+JDyT0T";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cbDcJDVI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j+ufSfDG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="40lN+QXO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CBD521DC0;
	Fri, 18 Sep 2026 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789731639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=De9LRtLm/CCPKm/EiJSS9zOl8AGubYjbc7atm8TLtyM=;
	b=V+JDyT0TnkkW1I6envwMpjB2yFlOkEslqB2cbxsiT/vRw3IcQ7p7dGwk+1H/eZReQREM6Q
	cppZYQenI1rfLdpUgdJaETPt0JzOV4nPvOWl4J8jSyMluiabow48jPwcBb/wY54LChZ/AV
	8Tn6vSplDALPMKeshXGqhMaE1vj3xPY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789731639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=De9LRtLm/CCPKm/EiJSS9zOl8AGubYjbc7atm8TLtyM=;
	b=cbDcJDVIRD+I1n/FZN98A99MY9e8NSwbd/Eh8fwCGkCdYjUEzYIeuKE/inpL6WU3hwXBt5
	D5LaOTC5W3K2tsCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j+ufSfDG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=40lN+QXO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789731635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=De9LRtLm/CCPKm/EiJSS9zOl8AGubYjbc7atm8TLtyM=;
	b=j+ufSfDG1BackLP7wOrP6xdAdLXz786oIxVtELTGVeqqAxf5ue0r+nv2GRKj97oeCxYX9R
	lo2Sa5xPxG5jl0tsxWpsZmykjllfNDgM4PnpIKUcUGDn4KgQR4OO4Yi2JAi2qzpgWxEFHl
	TeS/Ey6Y4fC+tJLRmUJsMH2V6NC9AuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789731635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=De9LRtLm/CCPKm/EiJSS9zOl8AGubYjbc7atm8TLtyM=;
	b=40lN+QXOz3f15Na1Era//Eywn8wmd8Wywa+n6vBzSDK27+rR+oQ5u19OTejNS6jjRP1ZTk
	Yt17eTZF5bDiidBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C3D81348F;
	Fri, 18 Sep 2026 11:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xkE3EjIjrWpRSQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 18 Sep 2026 11:40:34 +0000
Date: Fri, 18 Sep 2026 12:40:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yu-cheng.yu@intel.com, vbabka@kernel.org, 
	tglx@linutronix.de, stable@vger.kernel.org, rppt@kernel.org, 
	rick.p.edgecombe@intel.com, orsonpeters@gmail.com, ljs@kernel.org, liam@infradead.org, 
	jannh@google.com, david@kernel.org, dave.hansen@linux.intel.com, 
	yanglincheng@kylinos.cn
Subject: Re: [merged mm-hotfixes-stable]
 x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch removed from -mm tree
Message-ID: <aq0hScEaD5kZ1y8C@pedro-suse.lan>
References: <20260918054346.05DFE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918054346.05DFE1F00893@smtp.kernel.org>
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 9CBD521DC0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,intel.com,kernel.org,linutronix.de,gmail.com,infradead.org,google.com,linux.intel.com,kylinos.cn];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

Hi Andrew,

On Thu, Sep 17, 2026 at 10:43:45PM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: x86/mm: fix pmd_modify() dropping the dirty bit
> has been removed from the -mm tree.  Its filename was
>      x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

You might want to drop this commit. It was already merged in
704340f1cd0dcef829eb62f5b48ae95a2ce17bdf from the tip tree.

(Linus tree f7491d7c81db0e7c304a7bd757a76d2fbeaff80e)

-- 
Pedro
