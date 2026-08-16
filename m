Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8F713C9C4
	for <mm-commits@vger.kernel.org>; Sun, 16 Aug 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786887276; cv=none; b=RTIy2hhm1YpFRVVNyOAOfCywH93icmQo6hxePPP7vshqkAyFJWkY4FLtjTKn0Dmvlq+l5fH2Pz1pRIcg7Ytjv06EJfKUsxFJ6dihkoujRrfAyfu5ODM27GP8G/uTeT0F3yfL5ICN4z1m+4gLD+pM6k2COgkyHWG/jUDZxaIEjoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786887276; c=relaxed/simple;
	bh=i3Hrly7bt+yFoHa8+EOOb3wFJh7QLx2cMw3T9LkEY9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEJJkyum2tmBYnifhnU/qlfqwqoNlKUzqXAojJSSUqNmSXOgN/QEUuUUk0MYg93kE7H1+lFK7bRiKfBsJ3uxAKdEXBsudSmX9FzdWe25KcXHu7HpgBEtnGus+jE3dKXBJ/zKQ4bccEpfIRrDHdSViB5Pjc5vJFD53WgAW+9SiY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2Thewq0; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2Thewq0"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c05dcdf49so29962081cf.0
        for <mm-commits@vger.kernel.org>; Sun, 16 Aug 2026 06:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786887274; x=1787492074; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RmT/AGzwEAxbVkUvJcJEXPv+tY662th9KIiDQPj5yA4=;
        b=h2Thewq0mG0AwtrGRCYYeXwt3KiWfI6avC9SB6vgf8g6wOuLBSi/ay+Yr0PTCfPcGG
         tACk09DqeR23LFqCptOVp+LnJ0WApju4URcI0zL01QqEcM65y3tH1iR1Tl5YFZIDSY0g
         Dqng1PXbldD/nIs9m66Mse3hvLR+j5gxV/cSXQaT3FrRCpQDfwNXUR69U2pvJhv4zDyP
         fvH/o3yR1Rxr2KponxOaZTQOfwydFzr2/e7lxiEKd0sXfmnPHE0r0GrWmjCh8WTqH1LR
         k7j5vsDoGPJ4h3MO+W6BuVtOUCdA4cPKsKjxBgtU/+g3L4DZRcXtMvM0mIuWhe4Oobca
         bEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786887274; x=1787492074;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmT/AGzwEAxbVkUvJcJEXPv+tY662th9KIiDQPj5yA4=;
        b=nEN09OAjPKuwoF5IV9g6BB3l6S6ffLB+PU8RGXG1WH1YmouBMWfXPE3NLj+X01mGEF
         rXxsufO8Gqamzw76eWtdJDe87nyeOZan0ZYw/grSueAF9aUb2pSqVxNVjJIBGsL10OGS
         dFPQNcQQAfdwH+DN/m5X9bdm+cqayMM0zsfpytDL3FUXNKmXe3sjuSYsGFRE3/BRAu6Y
         W2pjtUaEBjtU+QcTZeE1rYFQHebpTexLwFb2xs/P+1x8RpPgdvaytIeRo+ZrXq9ruWkm
         n2nJEAI7sqxlVddIeU24TRNs8q6UyqYRUsYwCxdBC21nvo+/GjhsGUNVA6SwhDk/rKRO
         T6TQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBOkrKs7EvnjOdWILiDRdU02fFJPs6I/BvgoZelOHLL/ZjDy8A2WiFmR4ebhvk1L0WcOzqZyHBE3ig@vger.kernel.org
X-Gm-Message-State: AOJu0YxBGgPOJ94ZSXThj+HXpqp7NNutB+pqX1v+TumWxtMyvc0btI71
	0RtNA/+PFcHo3Qspq0Fon2Xff/EzSqHsbPwxc4P/1a5L9OXBdLxjDpEO
X-Gm-Gg: AR+sD13IV6I7igU7zgdqPLl+XYzKWkVDQF2hUq6AC5hDpoh0BFPu7WftXzeWgW6Jupp
	S0l/fDsC3PBPNy/2CMVwXymFVc7hggnv2ll8w+/dUQBag3K93qCdFJ/Fojb8yMyZJ5HvRawgqNF
	mcV2mw7hLCQNXQMbmwPyyGjiM7kEt9aXV+B/nf5kRZE5N12MEg+aOad7QNm6apPoyq5kPRD9eM+
	ub7K1kWcQz/BXilaqL1dlzPu0FvGWLxdyYct/4Deu6UE1RFGEmvfGwvvt932fKXoPrMZjJg1B/M
	rFcyMO2ahpxg8XohVx1zPDsTR1H0b2Zik2wHqzuYYgV1ZPx6/wzMqIsVV8Hd4f11EEBuusX7dgJ
	m7RL0nB5d5Wj+gUOqtcOa9dfXD6BvZJYwhowu6CGuf33AIQ5XuO2PEU7x5a9tvlh/0g4VJw4EDN
	kwoBzcCMipJVmwinXcAzXzjFtQKVGtcEn3QBauBtbVB4JHtyliNfYu6jAH1JnaxHw=
X-Received: by 2002:a05:622a:8d12:b0:52d:918b:92e1 with SMTP id d75a77b69052e-52d918b9790mr143650671cf.5.1786887274314;
        Sun, 16 Aug 2026 06:34:34 -0700 (PDT)
Received: from skinsburskii ([38.69.194.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a93594436sm59883946d6.46.2026.08.16.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 06:34:33 -0700 (PDT)
Date: Sun, 16 Aug 2026 06:34:32 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <aoG8aLLa2l_G1GRX@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
 <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
 <anu1N-DOnQwxO1kF@skinsburskii>
 <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>

On Tue, Aug 11, 2026 at 05:27:13PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 16:50:15 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > > Caused by
> > > 
> > > 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> > > 
> > > 
> > > Stanislaw, you've previously said that this is a can't-happen, but boy
> > > I'm getting tired of seeing this warning report.  Would the below change
> > > hurt anything?  I can't immediately think of a cost-free way of doing
> > > this.
> > > 
> > 
> > I think this change doesn't do any harm.
> > Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
> > behavior?
> 
> Like this?
> 
> 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> 			if (hmm_vma_walk->locked)    /* needed by sparse */
> 				*hmm_vma_walk->locked = false;
> 			else
> 				WARN_ON_ONCE(1);    /* broken fault handler */
> 			return HMM_FAULT_UNLOCKED;
> 		}
> 

Yes, or even like this:

 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
 			if (WARN_ON_ONCE(hmm_vma_walk->locked))    /* needed by sparse */
 				*hmm_vma_walk->locked = false;
 			return HMM_FAULT_UNLOCKED;
 		}
 

Thanks,
Stanislav
