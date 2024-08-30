Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30681A2850
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725023334; cv=none; b=II3LqSi60L5PWOyBpEpyVL/KMKV3bHUsFdRaxU+iCdnfRxjirjDxP3BnAIIcIG35ST5npAOikakqOxAjSJhZY4kxQE1Co/teo23dqEn81P/IS0hFm1QeLi4edEf2RBTrkxc1FBa27w+bckFPd9JaXs4Nn0qazANXB6zgjJPZL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725023334; c=relaxed/simple;
	bh=ir/rRP/xwQD1xCn2LYekhNo1jHb+t0E+u9nntzfJgqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rj8l53YihBix2z/AA0u6Ux/tavjzUdz57eu4FDX0B27SMHVazqBVkmMh40Z3EUqErVYYNicWI/c8S89zOdOk8JQ9CqKJIhqacY1k9vp/x+6MHjF0tkWQ1YMh9KTqae7437zbeoxG+QF5WG+csKusyRN5hMO8cp1p3dIkzCWb8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8BO113D; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8BO113D"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37196681d3bso1160351f8f.3
        for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 06:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725023331; x=1725628131; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WQyzbmRu68QU8VeltZmjYN8+8Au5DAuISTtQwEMld8=;
        b=R8BO113Dtxpat0ZRq3Oo/TByP6q/D2xANg4z2soebWZt3atoIgO5lpbScTSDWAEmsI
         z4ZpY/NT0VrOT53YCa+M6Z9jWLPBRV3JFiVOXnRl8W8IrX041WWcE0HUsSYQrx45Dmrd
         DAaV1PkbXzdZC6Xz5DobUMCwc3BydWVvUuxl0hK3MKI74Ztix1bPC/MBPEk8Fa1rbhJm
         sL+mEwZa74cPMedmPi5cM9tXMIMawYIHnolOJlixN64yA71jgvzn6mtszIRU5m8uut9P
         OP9i8qFK72QHapC6aGmv8raqZK592voMtz1cYmOgrHCl3LOqJu8qgbS6Mvo4TKKlGcU+
         B/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725023331; x=1725628131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WQyzbmRu68QU8VeltZmjYN8+8Au5DAuISTtQwEMld8=;
        b=JZMomTSnQ1B2Urpn8qwNuMqqEK8xqgWwGNiR27VXLeVUfZS9w9xHf7OpOvu21cNNZn
         flz9sD8b+Sl4rnt/Ty64bQibpUoyOzc+EgA0Zw4ROTwNR0SRaqhIEVn8NhehFmUJZX9C
         412Xhs9/cwcKt+DhxvNEhupLrg7X40/IKPbutSPqQioDFYAiiDrkF5UFPhReuL8y8FJl
         MFsEiOhOTPabxTiBUxdAKvWoqCvl9Olj5LJYKa5Ig4qFiRhhypOoNk3sA8bm9TWG66Ez
         9Oo0izf3ezjfcVHtpmxDQbnbgB3UI6DbBuLjWuvrl4Jf8dgc4UE1sV24Nik1sBWXhiPU
         xu5Q==
X-Gm-Message-State: AOJu0Yxhzu2aYqw0t6tRQlF2aGmSOCZ4rMC9XurtIdRCylX3Vx6Stftr
	VPyLBLDz9bMQW8wccMtFrXUfMyA8IEONU/ORkAW2uB31ZK66KT5n
X-Google-Smtp-Source: AGHT+IFGvkOe7LLFPdmBxoGL8SUp4mb+v+Ykw5Sc8e/WPr3w7zE/65PgxqrXHQgpN9FpIHcZLmz3QA==
X-Received: by 2002:a05:6000:c05:b0:367:8a2f:a6dc with SMTP id ffacd0b85a97d-3749b57c610mr4016930f8f.44.1725023330482;
        Fri, 30 Aug 2024 06:08:50 -0700 (PDT)
Received: from PC-PEDRO-ARCH ([2001:8a0:7862:ea00:1d36:5f53:3f57:14ad])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4abbesm3973840f8f.23.2024.08.30.06.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 06:08:50 -0700 (PDT)
Date: Fri, 30 Aug 2024 14:08:47 +0100
From: Pedro Falcato <pedro.falcato@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, 
	torvalds@linux-foundation.org, shuah@kernel.org, mpe@ellerman.id.au, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, kees@kernel.org, jeffxu@chromium.org, linux-mm@kvack.org
Subject: Re: + selftests-mm-add-more-mseal-traversal-tests-fix.patch added to
 mm-unstable branch
Message-ID: <mnmxmvotlkekjnue34h26vuusnsko2xzkl7a33ay7tj5mibr67@awdgppushunh>
References: <20240821020807.755BFC4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821020807.755BFC4AF17@smtp.kernel.org>

On Tue, Aug 20, 2024 at 07:08:06PM GMT, Andrew Morton wrote:
> 
> The patch titled
>      Subject: selftests-mm-add-more-mseal-traversal-tests-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      selftests-mm-add-more-mseal-traversal-tests-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-more-mseal-traversal-tests-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: selftests-mm-add-more-mseal-traversal-tests-fix
> Date: Tue Aug 20 06:51:01 PM PDT 2024
> 
> remove incorrect comment, per review
> 
> Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: Pedro Falcato <pedro.falcato@gmail.com>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/mm/mseal_test.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> --- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix
> +++ a/tools/testing/selftests/mm/mseal_test.c
> @@ -774,11 +774,6 @@ static void test_seal_mprotect_partial_m
>  	int ret;
>  	int prot;
>  
> -	/*
> -	 * Check if a partial mseal (that results in two vmas) works correctly.
> -	 * It might mprotect the first, but it'll never touch the second (msealed) vma.
> -	 */
> -
>  	setup_single_address(size, &ptr);
>  	FAIL_TEST_IF_FALSE(ptr != (void *)-1);

Hi Andrew,

I was looking at Jeff's patches and noticed you deleted the wrong comment here. Can you
please replace this patch's diff with something similar to:

----8<----
diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index 0c41513219ae..01675c412b2a 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -1027,11 +1027,6 @@ static void test_seal_munmap_partial_across_vmas(bool seal)
        int ret;
        int prot;

-       /*
-        * Check if a partial mseal (that results in two vmas) works correctly.
-        * It might unmap the first, but it'll never unmap the second (msealed) vma.
-        */
-
        setup_single_address(size, &ptr);
        FAIL_TEST_IF_FALSE(ptr != (void *)-1);

----8<----

Thanks!

-- 
Pedro
