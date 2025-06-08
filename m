Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB1113E02D
	for <mm-commits@vger.kernel.org>; Sun,  8 Jun 2025 22:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421896; cv=none; b=JAuoccR5rlk1eMo6KBiG6NHHM1EZf91XgxX4AHYm/ku8/UB4oMN70zTRwXjTmjmMRaICGStqxOjc3uTflbF1hDHY5lysWVCWib7Ip/Wpa2El7kZNj05Nvbi/MZG4JXVflu6090muNbSDQlrfBzNorw9F47PQGxCNotE+1upv0Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421896; c=relaxed/simple;
	bh=jL7i1DnkbJqpXbu/Qz6ST8q8bjNHImsDdaqBbfcJSYQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=PUaRC+hDQnKJddGqIETCpMzDraavZqfFdiLsYujc9+7SXHSF0Au59matD/y25FOYvf0afppfYZ9fgQ1fmgAZSUTIUk/CrinjERnVw42qWVpiH9X2g7cUhYDT9aMyugIKsO0f6houowluvUH/9soXZtuo4eIx6m66sDFfOKHutoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJ8/iqlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJ8/iqlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D51C4CEEE;
	Sun,  8 Jun 2025 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749421895;
	bh=jL7i1DnkbJqpXbu/Qz6ST8q8bjNHImsDdaqBbfcJSYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aJ8/iqlhrVwG8s4bYkyuc45P7CDX0s9ceK14cXE2Laf0WHVYNwNAai5+6BIKaV0vB
	 V69L8KNPys0jLnSO9HlyrAstz2fYViuk9v/g6vJCs2Hh0XEmGfeMI0bqwVfVE/4kpn
	 WsQ38A4hSx2ATq7jsYPmsvm6LyyfldKyupSfzaj8=
Date: Sun, 8 Jun 2025 15:31:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: mm-commits@vger.kernel.org, osalvador@suse.de, liam.howlett@oracle.com,
 david@redhat.com, christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
 andrii@kernel.org, wangfushuai@baidu.com
Subject: Re: +
 fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20250608153133.c34d47605c3a2e29e5115f48@linux-foundation.org>
In-Reply-To: <1ea4c4aa-d69a-42cd-a946-6f56d3b27f24@sirena.org.uk>
References: <20250607213220.E77A1C4CEE4@smtp.kernel.org>
	<1ea4c4aa-d69a-42cd-a946-6f56d3b27f24@sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 8 Jun 2025 23:21:19 +0100 Mark Brown <broonie@kernel.org> wrote:

> On Sat, Jun 07, 2025 at 02:32:20PM -0700, Andrew Morton wrote:
> 
> > @@ -994,6 +994,9 @@ static void show_smap_vma_flags(struct s
> >  #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
> >  		[ilog2(VM_SHADOW_STACK)] = "ss",
> >  #endif
> > +#if defined(CONFIG_ARM64_GCS)
> > +		[ilog2(VM_SHADOW_STACK)] = "ss",
> > +#endif
> 
> This is redundant and will lead to duplicate entries, ARM64_GCS selects
> ARCH_HAS_USER_SHADOW_STACK.

Thanks.  Thought so, was too lazy to check the Kconfig.

My modified version:

#if defined(CONFIG_ARCH_HAS_USER_SHADOW_STACK) || defined (CONFIG_ARM64_GCS)
		[ilog2(VM_SHADOW_STACK)] = "ss",
#endif

fixes this but is only useful if the Kconfig later gets screwed up.  I
guess I'll drop it all.
