Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877713D28F
	for <mm-commits@vger.kernel.org>; Sun, 15 Dec 2024 08:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734253044; cv=none; b=MFsDk986ucDAcavE+o6pFwTIzcxb4ywxwNYc6mFBEvGn4v+IL+iqLF8y6hD9ehm115E0nta74/SDhvZMS+Ea57XJXPeNGnWFs94lBlrnlggl7wzUrcbhuHPA2hdJRaJrwV2UtNSslfo87lLeruXbNiwOeRn0bWU1KlmGyv4y05U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734253044; c=relaxed/simple;
	bh=FB5CSAzTaGB8uqgNBSVzO9k0Xi2W/GChDiM0K45HS6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uFBA2A7dh/clmkY3CT3imikLcicy2YgFY9yelBKXHypAPj79Sh3JOeHxdIASICLHtLx0hezdC/C8M2FIoBu7fhha5uz8maXfbhNW8l/4pcDuV7485P1lIf7z2Vp2z3OBMqvjMr4naJuMEPCU16+syMXpDZawLaSeGL+ld+USEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BIrU4esw; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIrU4esw"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef05d0ef18so515589a91.0
        for <mm-commits@vger.kernel.org>; Sun, 15 Dec 2024 00:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734253042; x=1734857842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYJBrn5pDy0HAJYfgNhu+rAJLKb+JhcEDNPFaLxuFu0=;
        b=BIrU4esw3nohLyFdQltOt8xJPdWm440PwlRd4Y025k1wuFAg31KcdNL31YpJiL54Vk
         +bnQb0/xrzVvmFB4FUqAl4/HMKABFK1B53h32n4q4DudZ7dQFbKuKSIdV+8QBKRTr8e0
         S7RhHjqBCi5XLXWzGWhqlmwRdyTWFkbhrXta/Wt16qeOO4iyagPSgH+H81pUZEhlxIoH
         lfUqoiEXL0ouKKs24OipEn44IVIEtNEZjZDhhQoMB6BWkWHRlOH7qzVyKBahfbbYN5EN
         y0EW0nHSuVVGhqB6lCB+rFwS4m2/J6bLDcZ30aaSTx6Htnp+MNe+fB+fkdidY+djZP9a
         33PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734253042; x=1734857842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYJBrn5pDy0HAJYfgNhu+rAJLKb+JhcEDNPFaLxuFu0=;
        b=FMzI8dRinbC6iWQOHymvxRfu7ls00Lh7i8JeaC3XXaYqWYnVIAw0f6kmkSb74luV2w
         eNIlbWfJacYJjEiUwWzRR/XT2j11ph5Rnamxng9tD5MhIltc6FW7IPoITYcvG6DgZcYw
         Nlg6ws7aO+nMwH128hqgR6ou7GijVSI4lkaXMiDEGQWrxi7OEMt0pqeEQAqtvLI4Y6IK
         EKS45Zj/Bz4Z5VOI8PA5SNBh5DdXjxMQehJPfrEPy7WE8M1JbyCsNNRS/6flIDap2AhQ
         bUT0/Z4EWAHILRvuY0Gv7RElJB8DUB0Oy+b75TTvEPexrIr6Cy+UOp0W8KxiTJ2S1XYV
         i/dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbbel5uLal2nAt+cFw2PWslMyVVPPNcy4/BlEnRzKutl9ap4f5XtS8EryAXS0AMZNvJGDQ/g8j2uqB@vger.kernel.org
X-Gm-Message-State: AOJu0YwAGI8ecuyRihsRlCuGcJ9UkPcdIVSxKMx97C99qoSGKbIqxSYv
	hz5ZrgsioXtxzIc8HIdC2ahAmrRI+0O6Q4mNNPAAhnc791V3exM2f02wgCST
X-Gm-Gg: ASbGncsko3kGZLuykKyvFjde5r5OGRL58S2DRTekiUNtjz+rb9ocmiCKuaqDZnvXqcK
	R1CRk6vZKXcb9KCWnfM+ejLT9zIWhRRIrrplIh6xCHm0kZJn14hGpS4+o6VKFqKzD9+Ncowd4dN
	SYYilRgkpID7iX6lno/n3O53ozvTD1iS4V0/XSJ1ca/LjpA0d5Co70rEOg/Wiu2Y6QpsQCB2vWq
	E8ClCVSA7NBaF+BODF4BUhDN546VTJb7r83FgAum416Mz41JCxMTSOxfduw
X-Google-Smtp-Source: AGHT+IH0T4dEmlBtUlzVavk50DNlovKmhjqYLCyyF8QeW1cWTofyhOrnymhBUJ7HtNr6RqzmXZP0Ig==
X-Received: by 2002:a05:6a20:1591:b0:1e1:c0d7:74f5 with SMTP id adf61e73a8af0-1e1dfe303cemr5322034637.11.1734253042119;
        Sun, 15 Dec 2024 00:57:22 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5ad1f55sm2287508a12.41.2024.12.15.00.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2024 00:57:21 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Date: Sun, 15 Dec 2024 16:57:15 +0800
Message-Id: <20241215085715.165430-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <gxxr7y3honggqff4fgmss3v3hcnwplywkhce7al47ji3rzql5c@l3g6c6kpzzwg>
References: <gxxr7y3honggqff4fgmss3v3hcnwplywkhce7al47ji3rzql5c@l3g6c6kpzzwg>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two issues:
[1] data may change while ext4 is writing it to zram.
[2] zram is written directly without checking the length after recompression, 
    which may cause zs_obj to be damaged.
This patch solves [2].

as you said:
> zram cannot ensure that, it's not zram's job.  Nothing stops
> the buggy actor from modifiying the page at any random point,

It is not zram's job to ensure that data is not modified.
As long as there is re-compression, it must be confirmed again 
whether the length has changed. This way we can avoid zram 
panic caused by upper layer problems.
So I think this patch should not be discarded.

As for issues [1], i'm powerless.
