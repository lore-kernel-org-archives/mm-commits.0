Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B6117E9
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 06:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719471418; cv=none; b=jyWQycJF09SsfhtBMYXf7ppkEFsX0mv1Y/DZXB1GMZ/L0nAgf9mLRbiw6cevsNYLVIBelwJjMzo11f/GHYkcAhHq6K9yQ3g6vPhauh/vZa2FBUqdKNqtPMrUqHRPO/91w26jUfWXlTzuuaL+lSEcZ1CmAYf1ZRLA7NXtVIPPHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719471418; c=relaxed/simple;
	bh=EyE7UkadnoUeCVtbfwi3EbARgqAf6FHGqRnleGXgsi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNdPNxmqQlxyH4+EMfrmky2Qr2HPjwrg099eOkKtq047XSgXU+6F8eFMHOZxU4pxMMKuF8Wz4FJo3uo3Qo+USuLNQUx/6N/kI0sFcC2WZ/EAF+Ado/F/lKQkVCYmg2pz2MKfK20NS/GoEctjnljd3gu0tIU+Q8NLOcldIxJqYbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TxtI4yZD; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TxtI4yZD"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a6fe118805dso544197366b.3
        for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719471415; x=1720076215; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0HxwwdzAychYDIrvXXdci0MMT87S44nGKvUaRk/XFm4=;
        b=TxtI4yZDFuYFgry5wy5Ia/Rv35/b4hiWy2BRYLXa/3gevPFwBBGlm5puHhZ9A4FIcw
         FrHfaEz0cakCuhQEVSyTVkwUcStXOsqnCv7EJhkxKt2huUzTvv14TxANKD3owIUkq3vB
         HNPfkqa2hHsqr0GxX48fdriInZzdOGe4j+AyQO22c96WdLcoVJMuwPat/PVci3ljicPc
         JZpiRaEV7Q/1PnQjfXD2oEe2dxDd9JKpHbcawLW87kfkT8rOufiREB1H0D13NY0qBBW9
         O2nq7N16lEUaruy8miqPCgNKiFlMj9p7CLZo8Bw7p6LF+jfkddLrr92DQDcGTmjtGE1q
         MNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719471415; x=1720076215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HxwwdzAychYDIrvXXdci0MMT87S44nGKvUaRk/XFm4=;
        b=nPVl8SSJSHsCadxXgeYX1oG1wyePaO4s/CyHYNAvtJOP+lBnC01Kn3J52opJ0jfSOH
         gcDnRI9rRPpvqSaxBi8N9pzwzGG6/W7amPCluZ8qKI/zwxB3w9blyEJ2s5peaU529OqP
         qZUeCbnBTkYBcnCcRFaEeIO1GorFnDQRjkjyPwOzCo6nXaDSjvBZ9cZUkhbYWZr9pXxR
         q3bNWgX74QM1+wXIVLPqO3i+Fu7dth3dDEpEYxKFBjghAP8d0zoRtT67yYFgt735k4Z4
         NO2i54xDyziknnMk0bAabtVn1Y3SlmMwPMgdgaXyQFX+0xmbMcnNxnhVTJGMe6Nvym3R
         U+/A==
X-Gm-Message-State: AOJu0YxGb9E/kYlyLlk6uquDpUrtJiw50DeOjxTG+hrLe+BaMfKFibna
	PfgXjdKYXsR5LbGo/KaKPH+awf6yfvCJ/wmsfmnjZULWJ8Ft+C7tcLGae2rmSdc=
X-Google-Smtp-Source: AGHT+IF+yCwqhjPD0tR4gNPfIMLPE2TVB4xWrqaeTKzY5rXVXHoe0yce6OThgNOjbVjjcuDkdBV9HA==
X-Received: by 2002:a17:906:9c93:b0:a72:6375:5fa7 with SMTP id a640c23a62f3a-a7263756132mr695378566b.64.1719471414850;
        Wed, 26 Jun 2024 23:56:54 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d71f23asm30532266b.70.2024.06.26.23.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 23:56:54 -0700 (PDT)
Date: Thu, 27 Jun 2024 08:56:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
	shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
	nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
	hughd@google.com, hannes@cmpxchg.org, findns94@gmail.com,
	david@redhat.com, corbet@lwn.net, chrisl@kernel.org,
	schatzberg.dan@gmail.com
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-ID: <Zn0NNteypF9VfOxq@tiehlicka>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
 <ZnuxTAcFbW0mI5uD@tiehlicka>
 <20240626101137.135997396b4e184643e045a4@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626101137.135997396b4e184643e045a4@linux-foundation.org>

On Wed 26-06-24 10:11:37, Andrew Morton wrote:
> On Wed, 26 Jun 2024 08:12:28 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > On Tue 25-06-24 14:03:33, Andrew Morton wrote:
> > > 
> > > The quilt patch titled
> > >      Subject: mm: add swappiness= arg to memory.reclaim
> > > has been removed from the -mm tree.  Its filename was
> > >      mm-add-swapiness=-arg-to-memoryreclaim.patch
> > > 
> > > This patch was dropped because it was nacked
> > 
> > I do not see this being nacked in the original email thread.
> 
> Sorry, I thought I sent an email about this.
> 
> Yu Zhou didn't like and the submitter (Dan) didn't participate in the
> review discussion and the patchset wasn't going forward.

Yu said he doesn't remember his concerns anymore [1] and this has been
acked by several people.

> Dan, please prepare a new revision, attempt to address review thus far
> and let's fire it up again.

Can we just take the patch as it was please?

[1] https://lore.kernel.org/all/20240103164841.2800183-3-schatzberg.dan@gmail.com/T/#m0e4834bb45b975f518f297370edccafa8740a0ad
-- 
Michal Hocko
SUSE Labs
