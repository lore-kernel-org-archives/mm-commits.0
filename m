Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DA35A0E6;
	Thu, 25 Apr 2024 06:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714025219; cv=none; b=Dt+eJCaqotXmkiWoLYIbtNPL6jvJvlPZVA9mPz0JuMqK9WD7Kt7Rbp9kuEIIqAAJdxgtzjsLqu4h+3DbcfoBBoJ6HPzHAtIfUjzZ7yG5F1dwO7yUjFMlmVIFTfcO+rPCcSFGtYpylnU9VS5arVSxiOdVFLF3aBEq7NPHceO2qew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714025219; c=relaxed/simple;
	bh=SErOLhaY0W8NByUwppeuYmIL6sDxug32rav7h3Qy8zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPkBUXOZ4fjA7sDAn4oFTTnM1+O0Y9fzhSufD5DI7Qz/fQ2pZnJ3l3SmsZotaoWSdopSlBWK2m4G8oMqMUEm9wG3jCW6Zs5/Vtr9E2jioqTMEh5pp+D+sUtLTvSFb9FvKLYrN/F9sFfG0pBLODX80QrnGxOfa65HmBelwh/U1yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Wu5YkYSX; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UYgEemkC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Wu5YkYSX";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UYgEemkC"
Date: Thu, 25 Apr 2024 08:06:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1714025213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+LJgfqVJYncczb4YQubtSarG/Qnn18XEXFbxt6caka8=;
	b=Wu5YkYSXocDRNacpWj4hfEx0g6I0j4YUOZeMBNZn4q3jh5ub1ms17Em5yyU5Z/NCVvntrH
	EHgt9OeJsBE5ZF4zI6mwlkDkoM4/Z1v4I96skzvdXEH/e3g8shnnLljVOaBI7zh2eS/vIw
	4atK3LUfuXowp1RSPw4YxbdMoNQ3Y5R8oyNXET3RBnBv9quolm0JYDyrGsxpbz8khVXZb6
	oFRf+2mtaXnvyGtEgSCEb8YQetGHZRNM35rvE3T5s+ovXws1GqTrVokn9s6jtIRIooNBQk
	Xmd4HpCr1qxOnzhQiSsdH+9CvYmr1Yyhybk5js8y9f4e5UfVQgCnpURbkqdeXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1714025213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+LJgfqVJYncczb4YQubtSarG/Qnn18XEXFbxt6caka8=;
	b=UYgEemkC1u7cAkn8R+MwGtUccr9PG1jREndomSr0dPtktqg15Wh5yao8Oj+K4CoO4OOn2c
	uD9HMpdlr1CN8bAg==
From: Nam Cao <namcao@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
	stable@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
	ndesaulniers@google.com, mingo@kernel.org, mcgrof@kernel.org,
	kjlx@templeofstupid.com, geert+renesas@glider.be,
	christophe.leroy@csgroup.eu, changbin.du@huawei.com,
	bjorn@kernel.org, arnd@arndb.de, adilger@dilger.ca
Subject: Re: [merged mm-hotfixes-stable]
 init-fix-allocated-page-overlapping-with-ptr_err.patch removed from -mm tree
Message-ID: <20240425060648.6KBBZrZg@linutronix.de>
References: <20240425023525.ABB13C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240425023525.ABB13C113CD@smtp.kernel.org>

On Wed, Apr 24, 2024 at 07:35:25PM -0700, Andrew Morton wrote:
> The quilt patch titled
>      Subject: init: fix allocated page overlapping with PTR_ERR
> has been removed from the -mm tree.  Its filename was
>      init-fix-allocated-page-overlapping-with-ptr_err.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Please drop this patch. It causes a regression:
https://lore.kernel.org/r/202404221524.4954a009-oliver.sang@intel.com/

Best regards,
Nam

> 
> ------------------------------------------------------
> From: Nam Cao <namcao@linutronix.de>
> Subject: init: fix allocated page overlapping with PTR_ERR
> Date: Thu, 18 Apr 2024 12:29:43 +0200
> 
> There is nothing preventing kernel memory allocators from allocating a
> page that overlaps with PTR_ERR(), except for architecture-specific code
> that setup memblock.
> 
> It was discovered that RISCV architecture doesn't setup memblock corectly,
> leading to a page overlapping with PTR_ERR() being allocated, and
> subsequently crashing the kernel (link in Close: )
> 
> The reported crash has nothing to do with PTR_ERR(): the last page (at
> address 0xfffff000) being allocated leads to an unexpected arithmetic
> overflow in ext4; but still, this page shouldn't be allocated in the first
> place.
> 
> Because PTR_ERR() is an architecture-independent thing, we shouldn't ask
> every single architecture to set this up.  There may be other
> architectures beside RISCV that have the same problem.
> 
> Fix this once and for all by reserving the physical memory page that may
> be mapped to the last virtual memory page as part of low memory.
> 
> Unfortunately, this means if there is actual memory at this reserved
> location, that memory will become inaccessible.  However, if this page is
> not reserved, it can only be accessed as high memory, so this doesn't
> matter if high memory is not supported.  Even if high memory is supported,
> it is still only one page.
> 
> Closes: https://lore.kernel.org/linux-riscv/878r1ibpdn.fsf@all.your.base.are.belong.to.us
> Link: https://lkml.kernel.org/r/20240418102943.180510-1-namcao@linutronix.de
> Signed-off-by: Nam Cao <namcao@linutronix.de>
> Reported-by: Björn Töpel <bjorn@kernel.org>
> Tested-by: Björn Töpel <bjorn@kernel.org>
> Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Changbin Du <changbin.du@huawei.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Krister Johansen <kjlx@templeofstupid.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  init/main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/init/main.c~init-fix-allocated-page-overlapping-with-ptr_err
> +++ a/init/main.c
> @@ -900,6 +900,7 @@ void start_kernel(void)
>  	page_address_init();
>  	pr_notice("%s", linux_banner);
>  	early_security_init();
> +	memblock_reserve(__pa(-PAGE_SIZE), PAGE_SIZE); /* reserve last page for ERR_PTR */
>  	setup_arch(&command_line);
>  	setup_boot_config();
>  	setup_command_line(command_line);
> _
> 
> Patches currently in -mm which might be from namcao@linutronix.de are
> 
> 
