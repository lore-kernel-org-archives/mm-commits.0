Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349E04446EA
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788626639; cv=none; b=MGqOSFHYdlEHpTNiHzIqme7hyUwPpHu6ETthpdek4Tm1TBRbBB7qi7Xw/u9AEsOTzX2n1bqYXMNtB286e1RyL1+T+N+ptRvX1lsLRLnwpdw0/X8FkLMEHF5YgRbNE98W5QUA1ZlmhBG1SQzxKG4lIdwQ1Gpmv/2nbSmR9/f3tuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788626639; c=relaxed/simple;
	bh=VPVTdDOschktWqxbnpp2g+Cs7HVkwD6zFitEv4L4s6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJO177mWKQNEGDN6JtbrVz4Rm7YbH+63FVqEV6llmKCCaQBD6kkJrDOB4rTCmBGsewAe+7XZUf0IeU/uObHp4w5wxOE+nGUPzvaI3dTkiOH+hoQW0bQW+okJjJWr5rqzf4VyfKBlQncuCaRNWAE/R1e8WSg2s7vi5345F0D9BJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Sj3OcHTH; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Sj3OcHTH"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51bfad59921so26609521cf.0
        for <mm-commits@vger.kernel.org>; Sat, 05 Sep 2026 09:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788626636; x=1789231436; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2MnNWKE1aLOQVvI4VXrDjnmlyCcUk8F5PrqoE1ht1fY=;
        b=Sj3OcHTHfcR2oOHKKFynFV9ghsG+mcu7FEOZf4X/FqtaUqFVgIcdmYxghENYZ08ho8
         as2mxkCJ7b1JmIjjYjiofJrqELrg6kzaJZ3grAW09Ak9k4tX0oPjhxKqeospoCB09tdj
         p1yT6f1LL9tptaWgZlrHRMIoRXxfL9UJhzVum7rx4nvHj145L7QZ7OA6lOTF6jvxJHH4
         iFYRtHtseLBV5aBMvtdPyGzLUsWrk3wJIEvr1aZPJctiua8Kof/nYhPFmThf8DFez4wy
         3CwQtz7+0LJ6859LRD+22kfnDF114txhNGJ4ykJbzQHqF7Xhs6vCPF7BjfM3KoJkzTE4
         UDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788626636; x=1789231436;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2MnNWKE1aLOQVvI4VXrDjnmlyCcUk8F5PrqoE1ht1fY=;
        b=XLDjcCXKSxYzPLqkPSAcsXqH2F5vnvIFeE0KnXQsYmJ4PTjTZCVZOz2ClYcr4msV6P
         WWm9X4bTdH3qRB132cb6lX+BT/Wy+mGc0wabrV24xSmtai+F2hQc6fI5u9jaljpbBPRW
         coUgREwtND/+xeEe5oke6ZbkKxJCP9UQHHSswC9AzcVyQY8tqtUXrKr6aVF8AcToVtaY
         PYgDKx97WygxEZCoegFaWMH6TJ/BHfNI+yijER8819r9VeIrdRFkeoxTmkbyvX2aGfEb
         eUgIEw3+0JqSrDOWUGxiUcJJkU871CLO46nKR2eZCXJEylE4qYyJOpHPimB2VzG+MonR
         2uqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgcYIKYFl3sseG5/uUKhHGsLDxcvcZMN6c4LZ2C54mgmlZRbIlos0EpDQqyjEcTLbzSq9e5ndMIorB@vger.kernel.org
X-Gm-Message-State: AFuF++nXZcv0k3Yunwh5JrPU/Mk0uC+skkNoqrI5sy8yROQQ5/SLi7c2
	/pKzLV9/Qi2y3o4Cjw0CSS766FIJzhmqpPL3kVwjmuwr836EHb9siaKpfIXXjvcm5i0=
X-Gm-Gg: AYBFou0MAFV2NfLWuQOkRcMbFIwImhoBWYm2g2ZOvboep1YWZXDcXAje4LaA7ZcV5OU
	HorDjrOueU2fG/9hw96SMFpJrJhZO4fGYhkzlbmU7/0vYbp/4J6e91tg9mHB/2ENK79mCzS2I7/
	JjCrnbCkfVfdDGH2Xs07IHtlNtIrKkWJ4Q5L+60In8g6hOV7L9Q5biPlZsECqm2wNNQ8AQM48DZ
	kIdLj4dvv8fYN6XWlkhqit083KzW6vd61dtGcHRrUKnCx7KZUFSUhpCRNUeFQ1Mc/TgxuR7VaHJ
	cXDgIBdkgLL7mtlGiAtZI8eAzed/oTMJuDoq8/JcSUHgTVuckzpCqOTlgTmexRbOmtbhkJOymFK
	pS9+ExFk1Fzj5EViZJLIOxaIhfBgp4ym0YrRgAsoCtZaa83UK+iutRqPmckcrOntICXYt8KKagI
	7zqGB2mkKQUv5CSg/xek1MmX9DsqB2Bog813k3yl9r2ZIFc/1luH68iFrZ/KmugnA7wPwTVcXaF
	7pTGuxi1TxAgAomY6fJlHGMvQcwiDA9FjLZVaDq0HaK
X-Received: by 2002:ac8:598e:0:b0:530:3140:f0f5 with SMTP id d75a77b69052e-530547e047cmr134840771cf.5.1788626635947;
        Sat, 05 Sep 2026 09:43:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530541c86f1sm46782371cf.24.2026.09.05.09.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 09:43:55 -0700 (PDT)
Date: Sat, 5 Sep 2026 12:43:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13: warning:
 'node_is_memoryless' defined but not used
Message-ID: <apxGfmKgqnj0TDTn@gourry-fedora-PF4VCD3F>
References: <202609050628.ywCLhOj5-lkp@intel.com>
 <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>

On Fri, Sep 04, 2026 at 06:56:58PM -0700, Andrew Morton wrote:
> On Sat, 05 Sep 2026 06:32:19 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Gregory,
> > 
> > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> > commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
> > config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
> > compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> > smatch: v0.5.0-9187-g5189e3fb
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
> >     1507 | static bool node_is_memoryless(int nid)
> >          |             ^~~~~~~~~~~~~~~~~~
> 
> Thanks.  Let me try this:

Thanks Andrew, sorry for the churn.

~GRegory

