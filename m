Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221201A38C9
	for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 04:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711167259; cv=none; b=e2C9WMD99LxamRM13GhbgZL/eXCZiF2bEIz9pKxZC2hX0CQq1gS1n1fx72hrij1vn8UvY03x2sKUWdPsCcDzP8js0rApxrPvuj0RRVawY4/xnkjxffRWGzWEqGbMbWYIlSrTIKoq3lHCVdN+TUP9BMtVzzoQ2mYHT8dEuRoDQ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711167259; c=relaxed/simple;
	bh=VT5f9pCZjVYQpy2QMP6ne02CyeEfRAh4UUmCPlRbcKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HZu+GzYW09C/e3ojvqZgrIP8sw+ajWOBaN6l5+P4UG5/NLH8bWo1/C8CWQ7KfvLU58XSZp2ZBj0W+pZU43nh2cgdturtVTR2DURmje3gLTd3Dyrb2Pw2vPO9DKttiScpfzrPKPrRlzL0dWvbvUOFDRbuk2cnWEvIqL2skTJNwjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qv8jNaTv; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qv8jNaTv"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e6b22af648so2579846b3a.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 21:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711167257; x=1711772057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4qa7Xt+3vWmFN60pwDLkyxYhCTlKt+zdgQ0ZW0y4IA=;
        b=Qv8jNaTvNx7OJgU/Fwg6ZnVZY+8clBAJpgMfqUh3zWEoM/sPAH6vSyVD436nvmjxfF
         TbH6zuhWjs3/t+j6MmnnOb7Eal41T9hY5Cpr7ENL5czLxdg26Z53545xih6VC4sRRv9L
         dTqFHHAom3HMlzGcQEx2l7YAXy0Ao8u+TClJg/pDHkqeEE3gBqawTgAbJB0JM43QFPeg
         zUQ+jKuQPosxaxkkqTBgTAwOANI9IIUrVSw8NVgEuv6hLn4/TN8p1gSWukDg5EJgjFEK
         fgPimAJuDcR10m1H7U1ajAhMAsNDw2BY6rHyyPDxJT6n/2NWj/MVdXEEf51vMiG/zELY
         x0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711167257; x=1711772057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4qa7Xt+3vWmFN60pwDLkyxYhCTlKt+zdgQ0ZW0y4IA=;
        b=Q+z2vh5vy5E2oiIgixWZ7KdHpbHW9lrzk45pjl8oHQHc8TeeqL15eS2SU9HCP1ICzd
         WdBvskXM2QsLBU4H7KtGjyzWQt5bjSePoIHY3EkTut2LEY+MNd0Dpsc6U8AQAaCHDCOY
         w/5IbiDGIg3gPESLhd1posEEwVjj3WvKvch0HMcgjusncR8jV484MqoItKYVb/QYjF0D
         9+pdC4N/XNJkcZTD9tGH2Yh/X3293zFZuUKo0HcALHoX0WuranAHW2s0nluknlorYHIE
         dtRfJS5WpYOCXoL7RBVQ571mpRPJq9dQJuGiGdfttBAhu9L6DO0CnwcX9nVcxRqvVUaY
         8C1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhvj5CvoHZgLtKMv+zMvZ0lLyOHxM5CJQ1/Q+dwYItsen+j3lfob0ySYUBXJsAQfE6byWwIgpflMWryjDHWQHmfUbtLTRjsVpd6g==
X-Gm-Message-State: AOJu0YyzS6jwZXeM4AlZnoPcTYzMnv7Ys7GVnheQZO5BJ3Bl9kd7FixO
	AF9C8BxS3dzNpMSXs+kWoKG4YpsvjeiM2IKFy8LOvvkbkvKuWk14
X-Google-Smtp-Source: AGHT+IGFufXW3rRwjaDgR2P9fdei5HClwhKQVMlteSt35/J/mTHwB0Tw9lemkKG/9qgWNorqxrKl4g==
X-Received: by 2002:a05:6a20:12ce:b0:1a3:5624:a5a4 with SMTP id v14-20020a056a2012ce00b001a35624a5a4mr1132447pzg.23.1711167257338;
        Fri, 22 Mar 2024 21:14:17 -0700 (PDT)
Received: from localhost.localdomain ([2407:7000:8942:5500:aaa1:59ff:fe57:eb97])
        by smtp.gmail.com with ESMTPSA id dr18-20020a056a020fd200b005cd835182c5sm2063081pgb.79.2024.03.22.21.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 21:14:17 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: joe@perches.com
Cc: akpm@linux-foundation.org,
	apw@canonical.com,
	broonie@kernel.org,
	chenhuacai@loongson.cn,
	chris@zankel.net,
	corbet@lwn.net,
	dwaipayanray1@gmail.com,
	herbert@gondor.apana.org.au,
	jcmvbkbc@gmail.com,
	linux@roeck-us.net,
	lukas.bulwahn@gmail.com,
	ma.xxn@outlook.com,
	mm-commits@vger.kernel.org,
	sfr@canb.auug.org.au,
	v-songbaohua@oppo.com
Subject: Re: + scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch added to mm-nonmm-unstable branch
Date: Sat, 23 Mar 2024 17:14:01 +1300
Message-Id: <20240323041401.6335-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> The patch titled
>>      Subject: scripts: checkpatch: check unused parameters for function-like macro
>> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>>      scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
> 
> Conceptually I don't disagree but I wonder what the false
> positive rate is.

Hi Joe,

If your concern is whether this script might produce inaccurate reports, I'm confident that
the false positive rate is 0%. Xining, please correct me if I'm mistaken.

Regarding the percentage of cases where a macro function might not utilize a parameter,
it varies depending on the specific scenario.

For the code below, if flush_dcache_page is implemented as a macro on those architecturs
which have not dcache and doesn't cast its parameter to void, it will trigger a build
warning.

 struct page *dst_page = sg_page(req->dst);

 for (i = 0; i < nr_pages; i++)
 	flush_dcache_page(dst_page + i);


If we perform the following action before invoking flush_dcache_page(),

 struct page *dst_page = sg_page(req->dst);

 xxx = dst_page;
 ...
  
 for (i = 0; i < nr_pages; i++)
 	flush_dcache_page(dst_page + i);
 	
 We won't have any issue.
 
The coding style modification operates on the assumption of the worst-case scenario.
 
Thanks
Barry

