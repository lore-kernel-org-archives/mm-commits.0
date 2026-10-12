Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F446EF60
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 10:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800076; cv=none; b=pSiyc0KO6MLqDkhdEMTNa8VrxMvgImHNrW3Fqconvh+gxm8+FBpHX6OfYoOMQKYeVgaR0DqTDmhBB3L2o7Y52yAiZt7TjfNztpxiArIQXTMB9e0QZJvoKYDK+FCZ6uEfrld2fI3mQoAL7QdCmpBRx/S1gzFQBuXl606GPFO/7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800076; c=relaxed/simple;
	bh=bLanx5uvYKx3aLlpDQ+hbsUiLrvp2ShbaU8G1fgwZVc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfxmT4DW1Jbxj4bWKjHyKet/crCYCbw6nnCFu/n1U2pxjB5VHCTsKTsKArcT4phfFem+DuDv8Stn9+2gmZzoacv/aeIG/xdd/k3SVQtIWEezjotHwxssFVjuHYVMZWSLOiXHQzpSc7SnpYSq8wbO6RgwWQXEdAM1cz+86EHZq6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oThFtVEB; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oThFtVEB"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so12791745e9.2
        for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 03:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791800068; x=1792404868; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T133sU6/Idf+X7mBizn2U5ECJTsSfA4qf+8cqYy7fbc=;
        b=oThFtVEBVL1SvrIRQcI+5GVDqAQMinfbeMkLfFtzyfMBPeiH5Ed/f3bgrAdbD3O7mE
         FjOqoeF01SZbqDwrLIPo0bW0jnspE/01BjQ7rbHit55WpTvVkW/2FKrtlaM8MqNFY0ei
         Q31g6b77J3I+WAmrPei6+cNxg5vj8WvNX51w4kMSBTnzNpTV/Sw5YmJ/d5vPnPayQ94L
         lYdMUkQtPiXGGUh2G7ZGMgO6+4N8kbB4eDuyhsOhVYeRLQV8DtF9WKiCw98ZWkhgIee0
         3IdDDhKZEJnEGJlH2uk/fJBsmbYHYKRVtWVgZBdAgnkN7BiAyNPmT1jRc6JubLg5I2PT
         nglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791800068; x=1792404868;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T133sU6/Idf+X7mBizn2U5ECJTsSfA4qf+8cqYy7fbc=;
        b=ZVpLGXNNIpEp1XNvIJI4O6RMD4MJAEPsnxDsn8ZA1OxtxGjbncJs31xzobArt5tP4Q
         cM+T/xOYOiUG1zdAarP2XHxBGKDyYgOnde6ID1grxJbOhfQp3PyK1ZJCpVSsHszpnMhP
         asQIsqSi1HFm64B1CNeG/MENtw0w4t5PDxYNmRmnaoVkL3oLh0mrPmGYypqEMB9sGKbW
         aupBrNGCZdnCqqY6/84gZtvQClf9XdHi7tCtsggTbyyG3K9ZWMG9q7DrBN1EKW0P/MxZ
         Rh5ElvVX5e5Xw3dvPC0uGx7FQf+okRgTYZsr5u5R9OAADh6BqUXa91H9HU50usY5a95g
         1Lng==
X-Gm-Message-State: AFq9FYLdlgOt19VBnh5CnucSnwE31o2Ww+W1o9HwtbBxpobjfMHsxnMR
	vhF+PvmjWOnnit1tclB0wBrAHM4nr0LcErvGab6V9ALYyxE/NU5JGLiz
X-Gm-Gg: AYBFou0BruIc6AkZ/ORZXhST3ULQNa+1SFd5Pnn7QJCKuBZTRdOyPpNKw37/TCsqSUW
	UOoQU4C47phYlh7thGY13KtUV5SrjNixH2O73v0jvaYu1+dlMamCdvOJzzXtls+lKps+9RcxV02
	cjRqiqjR3vUykrbWh4xkB7ZEAfzMLPx1FhpOpL2V/yZ2VcqvvgLuDnu7F9n5fsAdBHIGXzapJLU
	8lpLyvEfoTozEbO4fm3GPAIgZuTn/JMuE1iQVoeO6MMWpfiA15B2WIPwlMJCIS8bgSk8JkNcNMZ
	w0PN7Ou5oQkmM7AOLcYcX94yAPE1Vr1NgyX8UPsGcho52fHlZ3ZoKdVDKMnNViMojUv9uPXokSf
	jptvdQHRuEIeXHhCIw2iVf9AtCEGWGVS3zwEt5a6n1B1CvGqYxgIwUIbtCU/GsRYbyVwlgieA8c
	q4OpEMn6IdL8qsPkdMfYZ4uKKtrRD9CKs0Rr9DCYQiS7dMwSEBIo3e1vRlENHMjl7BTYjAw3b93
	OF1PvpmXBuukqQKDF+Cu5dPFybUX9pd+yc=
X-Received: by 2002:a05:600c:354a:b0:49c:d019:70c5 with SMTP id 5b1f17b1804b1-4a18e3ef23cmr161777035e9.0.1791800067536;
        Mon, 12 Oct 2026 03:14:27 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ab981asm19150729f8f.30.2026.10.12.03.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 03:14:26 -0700 (PDT)
Date: Mon, 12 Oct 2026 11:14:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
 thomas.weissschuh@linutronix.de, rostedt@goodmis.org, pmladek@suse.com,
 olsajiri@gmail.com, nsc@kernel.org, nathan@kernel.org, mcgrof@kernel.org,
 masahiroy@kernel.org, ljs@kernel.org, kees@kernel.org,
 geert@linux-m68k.org, denis.benato@linux.dev, chewi@gentoo.org,
 andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org,
 jim.cromie@gmail.com
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20261012111424.4b88e041@pumpkin>
In-Reply-To: <20261011081552.e6f08178e6fc8b865e2715d3@linux-foundation.org>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
	<20261011154401.479c51b6@pumpkin>
	<20261011081552.e6f08178e6fc8b865e2715d3@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 08:15:52 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 11 Oct 2026 15:44:01 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> 
> > On Sat, 10 Oct 2026 17:23:40 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >   
> > > The patch titled
> > >      Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch  
> > 
> > There is a problem with the way this change in implemented.
> > Basically the kernel Makefile (etc) only builds scripts/kallsyms if it doesn't exist.
> > This means that if the header file is changed you can easily end up with a kernel
> > that expects a different marker density from that in the data file.
> > That will lead to all sorts of strange/confusing issues.
> > 
> > It would be better to put the 'shift' value into the .S file.
> > It isn't used anywhere where that will make a performance difference.  
> 
> OK, thanks.  I'll remove the v7 series from the 7.3-rcX queue - let's
> revisit for the next -rc cycle.
> 

The patch that changes the name comparison can go in.
That saves 512 bytes of stack but doesn't make (much) difference to
lookups because other things dominate (probably unless you have some
very long symbols from rust code).

I am working on an additional change.
(I posted a v1, v2 adds some extra changes and is taking a while.)
Performance wise it improves name lookup by a factor of ~18 while
only increasing the 'density' to 64:1 (1 bit per two pixels).

I've make the density a kernel config option (default 6 => 64:1).

One of the reasons it is taking 'ages' is because I discovered that four
of the 'token' values aren't actually used in any symbol names (in the
dataset I'm using) - so they can be reused reducing the main table by
~8k (in 1.7M).

David
