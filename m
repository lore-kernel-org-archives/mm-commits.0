Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BF541DE10
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764851; cv=pass; b=B7XLRPt5+iuD5IgoK2UNKXcq3dk8zIKSrylNBry6VnzPocGd4I3wXysmfhCtMHYxjWUnQxh2mtd+vec/9Zxq+6LjXsh2qmeODEVpLCOklRbTCTYtnquzKBFsuBSiIo77tRChmKiRARGB0LAwcMiFa/1eKTuEKB6s7uX5wvOkc2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764851; c=relaxed/simple;
	bh=+vVBZ8kXAnT9Vh4S1LIwWNR14eSPiRpKUVEmCEEYhAM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Content-Type; b=CfNSsaE+KSEsTO10WEXJ5Rr/PAnVgvVbgjdKZNKKu+HUcp3Dad8usIomNgIxeIlrgW4pXhBP6SvnIFzdz8P/6l8NXbJARONZbrXskb+81ljsuAsS+Ub4f2CDQGqO0b6FQ1/sJXn8K8BFEqcHaunAjTdAW24tSXm3wc7Fbvpx2oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gJTIRN88; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gJTIRN88"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38101f85591so3234920a91.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Aug 2026 06:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785764849; cv=none;
        d=google.com; s=arc-20260327;
        b=BSw7YN0Nf/vXgH3Mdd8abCSPGweZr8fgEibT1eL+F8Mk8xN7gmEXJSnlaUaCpZS1AK
         eVt6U19XS2Q0Z9/d/d3LrHohamBZFTXanyGc8nKyClTwwfVTV7vjxMVIdjdARhUmuYj6
         Q7lME2Rh6HH4X5Zq5JE5No3Qtiy20GszP5FbQYzI5IV5Cqac1ylDJuzYxDO+rnobHsE7
         EtnuWL9uG3dCDTV6RlA3unWAb1Ok/vVtZPNxmftVqZYVAQvalQmFDkb6XKxjJDchQAUq
         0jGTMz48mWPAUYLRJWkRohYzksHA3HVHnBdGPMqCauJxIkt2H6VWU7uVRt//4YU7oCx2
         dFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:references:in-reply-to:from
         :dkim-signature;
        bh=s6oroKdTPuBya+Pw0cnp/bJYpwRKbNg+BndANc4lgZ4=;
        fh=McBlVb1VljPRudX+u5QZ3scFbo2HQC6CZA6XfCiHlmM=;
        b=dI4yoW/3Q7h5zzx0N+Pz/7sBcggSBl2sQCRhajCfrqaz/ZGHkujEu6h005v82RwqWN
         6kWGVxcnp1xeOTcy3USOUGzlzUqBlPcAxLVKS3bD5Hz6AP+JRqlbTlvXGZaeKKQCL22e
         xJfSbCACfIPpEFhG6CvdSWJTfLM9jkh7lGrPJuUyDAuUDQO++0cyrQqkCcKdBD+YBSQ+
         KDr2Vq2iWzTcAfeFgf+4pKy5kHeJ5xM/l1lgjYTYIbC7aVKV38+9PCMWjdeizSYWzqC8
         Cn9X/6SHFGn+HNf1ZiaVCp5vPZLqVQ7y/LLNVQJ5c8uRM8XTUaaFH9J2bynbY3qzgv6h
         tEeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785764849; x=1786369649; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s6oroKdTPuBya+Pw0cnp/bJYpwRKbNg+BndANc4lgZ4=;
        b=gJTIRN88NAfgsYYCrOA4Z/eNi2xLJs6pl5s+xsOuKbpV/ETAjTxu/xG50QNrJfvU7w
         LybuRwAdVN3grdk5hR26+WLdlxuOAPQ0QLUw2dEFvKR14jvf2+OncCshJ48AyEF5Xd2U
         mUjvCutIWrcWUMYqyr+5Lr8EvtS32TFTkL0fPGP9btjN2hpBzeefgP630NK0ViOyAfxE
         w0KScSXvSqNloo9pHK+kDBZUUVP5QIFcab67j/HAjZuSV78oTWi3p+RiaEWQOSEIkZdx
         sQlWn9vcyOhiiIKbvr3Cxyw1cpkftYugjru/GwXypFDcC8o4mk8N5oyzFaVp2PLSdkTT
         yWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764849; x=1786369649;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s6oroKdTPuBya+Pw0cnp/bJYpwRKbNg+BndANc4lgZ4=;
        b=MyPmythi6MpXgideEpANked38JIakchU51RUI4OWrxzexqy/OJCoAugxZV2T2Tk0o/
         eFw+Awux89hr+U11HMRS+BZc1VOyWhymp86kY/sJYkulHOWrRNLA0A0YORUIXiI5uB4Q
         u0AY0FbPlVKtQ4EnE0HSvlBnGHfVkuxRDrwirY88LbRLPTb3Gp7JAIo1hJoi+H1vaV3E
         JbFYwAQxi4ai/u4sKg1KDb5YJ3c3rW3VHLTZ/Q2GcVJ7Dh1LOy5pyO98LaGp7m/QdRvI
         1mDZa7Sr1iGplvxzT59LdilW+vT9eB5DjjGgYu53x0lEYxGgJTxFh1P5MxPEH2WQ1ylT
         bXlQ==
X-Forwarded-Encrypted: i=1; AHgh+RpZxk2M/wDckwvPfvn4x9G8E4ZuRDBBcG+rh04p81Fg1n3JjTYljvSwr6thBd14Hw6ya556okvh5nFl@vger.kernel.org
X-Gm-Message-State: AOJu0YzGekGzq3l74gxk6d1WJYagHxp9xmaGMv9EbKJCLIiEf3G1j89o
	cry7Oo19iszRM6pf9QPtedu254GG//ljWkdRFf5Sfu1JW0WOwRRGGOLaQ1uQyyUZh3JrJrkTPqD
	Clg+qm+7Ej9NeKwS40oYlyoLJq+DnLMIeaMHFDUJ3
X-Gm-Gg: AR+sD13jSdwS5I9I4ZunPBpQHXPWq+7xnUOe0FzHyuov8BMzohLbIUAQZ3zj92i7NEX
	MraoSbrUNubTrPhF4nVyxzgGhBaEl3WOIU+fWFw0O2/cqIgMjFGdcJqhz1vhOC+lzuTeNoh0xfb
	WMNJyqrLuod9v6mQSYUTIysnl9sZEWE4KSWnRCOXM3/fLquJvtdkg6yVsDQZ+K9wFgALgMePMjA
	6hNpphdDJ9uQUNUyMsyoGq2Apw4rjUtkcE/T5bm9yL4u+H4NPPBqlk1Rz6mmRpIO/IG7UjvWE8h
	Sr01EdNbyDvevd1626hX/EVUpYUl1prG4kGkg79dpdTZwPj5mQc/rj+uSk4SzIEojRMN28uvwUc
	SgBn0xYUXV9g=
X-Received: by 2002:a17:90b:58d0:b0:38e:c1ba:4f94 with SMTP id
 98e67ed59e1d1-38fb2409a47mr11737715a91.2.1785764848630; Mon, 03 Aug 2026
 06:47:28 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 3 Aug 2026 06:47:27 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 3 Aug 2026 06:47:27 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260731024306.E4AEB1F000E9@smtp.kernel.org>
References: <20260731024306.E4AEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 3 Aug 2026 06:47:27 -0700
X-Gm-Features: AUfX_mzMHviohHWnRd0jben4gFp23c_FYb6LThUt87soUUg8yiP7syvMV9V6UdU
Message-ID: <CAEvNRgE63XQyW4NLBCU-A2yFSfYaGkhspAWMi1_kzPRNL3pJmw@mail.gmail.com>
Subject: Re: [merged mm-stable] mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, ziy@nvidia.com, 
	ying.huang@linux.alibaba.com, yan.y.zhao@intel.com, vannapurve@google.com, 
	shivankg@amd.com, shakeel.butt@linux.dev, seanjc@google.com, 
	roman.gushchin@linux.dev, rientjes@google.com, rick.p.edgecombe@intel.com, 
	rakie.kim@sk.com, qi.zheng@linux.dev, pratyush@kernel.org, peterx@redhat.com, 
	pbonzini@redhat.com, pasha.tatashin@soleen.com, osalvador@suse.de, 
	muchun.song@linux.dev, michael.roth@amd.com, mhocko@kernel.org, 
	matthew.brost@intel.com, jthoughton@google.com, joshua.hahnjy@gmail.com, 
	jiaqiyan@google.com, jgg@ziepe.ca, gourry@gourry.net, fvdl@google.com, 
	david@kernel.org, byungchul@sk.com, apopple@nvidia.com
Content-Type: text/plain; charset="UTF-8"

Andrew Morton <akpm@linux-foundation.org> writes:

> The quilt patch titled
>      Subject: mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation
> has been removed from the -mm tree.  Its filename was
>      mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>

I've split out the first 3 patches into [1], which I think should merge
first. Thank you Andrew!

I think the second 3 patches

+ https://lore.kernel.org/all/20260731024305.877EC1F00A3A@smtp.kernel.org/
+ https://lore.kernel.org/all/20260731024306.E4AEB1F000E9@smtp.kernel.org/
+ https://lore.kernel.org/all/20260731024308.5E00C1F00A3A@smtp.kernel.org/

should go later because they depend on fixes in [2]. (The fixes slightly
change the flow in alloc_hugetlb_folio() and affect how the second 3
patches should proceed.)

[1] https://lore.kernel.org/all/20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com/
[2] https://lore.kernel.org/all/20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com/

>
> [...snip...]
>
