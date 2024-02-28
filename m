Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6286250
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 21:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709155580; cv=none; b=CxFKKIPCXrOWR+ddiS4MoWJ9b4m8aGt5ExmJCLRY4BB687GSTY1QUTFE3QTHHDxM4Nw9mBK0vfc9WiahwqiSR/KkYq7CfaQ8M/8ug81k42xch1UxRChVYpFNJIRCS1aCPyc1IKnBXYqapR9Va8wv4Jh2vrLdbToG9URuLfEV3WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709155580; c=relaxed/simple;
	bh=+JtCGZNEm9xTpdiBfCsCYcfsA9Buiu39Eio4leYVpqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X4D1shn6dwpWDRbuX5aR+uOQJlX+msGrxeZZRko9hqGQNfFmX8S5nPJhvcNnwGDoQ3nOygH/8XeSdVWyppjgKKPAyoiXY/d/pDKXSa10cmSwKHh8d1RrLtyOOl9r2wq1cTXeKmMy3EKEb75C/AIAW/8VQgDXctGm6qOB5knTLYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjDnBkoJ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjDnBkoJ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so144959a12.3
        for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 13:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709155578; x=1709760378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ucwF2DYmEKeNujeEEpGZgDCNrU3ohhAeQTYjtVzxIuQ=;
        b=SjDnBkoJcndNJ1ty5TTxC9PvHWNkxHiHyk37+ygaqVfPRIXhq6Tq+uW9voQrdZfX3g
         Bs9evq2q1ilK1PcvUEUrs2m0OZ4AU8x+gLNDpP2+C23huVsCW3hKBkAH0l225kb7/d/0
         xDuvgysC7d+73wPDgNvrkRD2x+fKMLK/Dr4XPJh5a8DLe7fvg8dHpseoGLTbrO5H4zYh
         /Ijhu/UdOF042T56itQQDQ3nJ+8P6z5iFQgSEagv5LCiKn4JGvAqMAXk1If83Q5+iVdI
         ZsSgBWURrOlrYwS64Wbq1oQIoF3U6DLK2YYtRsciMk9uMVFAGEY93LsimJd5+3MCS+m8
         XlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709155578; x=1709760378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ucwF2DYmEKeNujeEEpGZgDCNrU3ohhAeQTYjtVzxIuQ=;
        b=Qbk5qdsEeG4PoY2k6/t4jsbAdi0bT2Rf56eeckt0iy5zVVoW5I6A9XzZr/pGkCdBTQ
         RPy8AZxu4ooWDTvnqd29WJ39QH4ZKsROTlyR/Fe0bAQ8kptNwRK2srxlPhtonIPZgtxZ
         5c2pfmA29jaWCOmVr2xnqkvafBYnXKj5Q2RrR39MLxLKUjgmPCPw9XEYWoWxUUOAqDOn
         wdzU6YTeWs5Dofu6gfV4Z3T/e3Dx1khJFket8xntkpd3GSm2JOu4Rwb1EOXR6GIyd/W6
         l5tyOdnykTrOSbnYlQT/dlbMQ+1Fai47z0ATOvXYBo8izdcPBnTdAER7RJWo37/Bqqka
         td7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdraCoAPEJp5Jfyy4NrrniHCtHwh7zmBhs7+xyBuSgm4ITHJYF+TjabqvMNcBmg2un72y0zlBqKzKr820XlchUeWEMHEa6f4G8Kw==
X-Gm-Message-State: AOJu0Yz0xASZIxUA8KubsG0HRr4wH/n+oM8u0KJEwjVGeJsRcqcIEG8r
	NKYu7jbIMsM2SY3P9z88JuuYppBE471zAC2wxbEN6dYNenojwIK7
X-Google-Smtp-Source: AGHT+IGBKoRRaX7r+SU93DpY3RDkMNY9eq8z1DGlUWGB4+isPP2nQJlTkYOTUy7d8cHrdig4/1BKFA==
X-Received: by 2002:a17:90b:2683:b0:29a:9e50:81ec with SMTP id pl3-20020a17090b268300b0029a9e5081ecmr364008pjb.35.1709155578041;
        Wed, 28 Feb 2024 13:26:18 -0800 (PST)
Received: from barry-desktop.hub ([2407:7000:8942:5500:5158:ed66:78b3:7fda])
        by smtp.gmail.com with ESMTPSA id ok14-20020a17090b1d4e00b00299404af11csm2173079pjb.36.2024.02.28.13.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 13:26:17 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	fengwei.yin@intel.com,
	ioworker0@gmail.com,
	mm-commits@vger.kernel.org,
	ryan.roberts@arm.com,
	v-songbaohua@oppo.com,
	sj@kernel.org
Subject: Re: [failures] mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch removed from -mm tree
Date: Thu, 29 Feb 2024 10:26:01 +1300
Message-Id: <20240228212601.7972-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240228182757.75871C433F1@smtp.kernel.org>
References: <20240228182757.75871C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Date: Wed, 28 Feb 2024 10:27:56 -0800	[thread overview]
> 
> 
> The quilt patch titled
>      Subject: mm: make folio_pte_batch available outside of mm/memory.c
> has been removed from the -mm tree.  Its filename was
>      mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch
> 
> This patch was dropped because it had testing failures
> 
> ------------------------------------------------------
> From: Barry Song <v-songbaohua@oppo.com>
> Subject: mm: make folio_pte_batch available outside of mm/memory.c
> Date: Tue, 27 Feb 2024 23:42:01 +1300
> 
> madvise, mprotect and some others might need folio_pte_batch to check if a
> range of PTEs are completely mapped to a large folio with contiguous
> physical addresses.  Let's make it available in mm/internal.h.
> 
> While at it, add proper kernel doc and sanity-check more input parameters
> using two additional VM_WARN_ON_FOLIO().
> 
> [21cnbao@gmail.com: build fix]
>   Link: https://lkml.kernel.org/r/CAGsJ_4wWzG-37D82vqP_zt+Fcbz+URVe5oXLBc4M5wbN8A_gpQ@mail.gmail.com

Hi Andrew,

As I checked the build failure reported by kernel test robot, the tested code head
20af1ca418d2 doesn't include the above build fix, it only has the original patch
with the build issue on NOMMU platform. But the above "build fix" is exactly
fixing the issue.

So the tested code by robot doesn't contain the above fix, while the removed patch
includes the fix. So would you like to take the dropped one with the fix back?
Sorry for all the trouble to you.

Thanks
Barry
