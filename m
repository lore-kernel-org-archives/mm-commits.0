Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16C20F1
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709079879; cv=none; b=TQuWWJjJP0mcWvFJb1yMiJdpnOmQEPn1fGu7A+9Wycj8ScJlAO2XkMj9UiNgbfGBTJ7EVIDp7bhUbOFotDALWV0i0/EN6tB1BT4G49MDTokFV1C3vQxZt8k4OfcFr/JmajK9mEltg2Tbd75VxSrpXWTAQ5hqaVdxDSQPFY+K97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709079879; c=relaxed/simple;
	bh=LYrKbPHWLml2bvm8zhAC7qF/CFfPbJu5eViHRcrFp64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NWz8ER8rLoTqG5iA0O6czD2y9Fd0gxSBA19WaR3NqWH7zZsckouGZ5TKR5zY/XOHvOJ5luhJrN3vb45uH0eUYchuJvVIj3LYO4B1G3lpyp/xBX76+6zmx91cIX//Q2OFJTlqaKlmQ6qDbw+Fvh18/z7r1XqXZLEsGFJA/xRXLX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GcSnUiwQ; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcSnUiwQ"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-22007fe465bso1652847fac.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 16:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709079877; x=1709684677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oz/B2jpPzwIdZv2wXNfQGjmi7V0Ox35xICFJKQ2JPZg=;
        b=GcSnUiwQYyr8peDIka+RePIt2A1bY4euwfdT9zWkXka7t+KIaq2RBiscJGL5dVsWK8
         dSfkg6tGtcPgRmbcJ6YzMGQG5T7oYarjqxAqXSA6yw9FVVn2yryZXZnIjSebPXW7YTtK
         5yaL6mGFVTmXy36E3wdUlQeqWTDYc/hhhd7F9M8ywJthKBnWr+bXm21KbekAaXspOdK0
         7A95w3zdnsbOfjpmUUY33Qj/8VYseDiLJg6CaZ+MH5j0C7R4NPVQ6sDtxsvpMK1dwxvT
         sHDF4rdbMCEjiBKUzuhMLV6CL38Hfa2v+St5g8JpUljCF2sFqSHLFgEgge7Sw1b/jdQM
         SFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709079877; x=1709684677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oz/B2jpPzwIdZv2wXNfQGjmi7V0Ox35xICFJKQ2JPZg=;
        b=EhkXl20Zg3UOYttDuc7aevh1yBScgvv42hFC6hieAOH493amiGATHJmWHD9q7a5Ph4
         0HhpJydbKcK9RqzEVEa+d4QfnPZYIZ/p7b9YsGB57L/XQ+TK2jIH9BTm1fpHjOlFP5Dm
         cyBd+V5Ntdv6MyH/lv65mWBf2IEzOoBGgtzkEidisogd6BT/rhNZhZ5tPjqn0SOd82Jx
         b5gSjL2u39M7ILOt0lC4i0X1R5xzg31FE5k7ySsNBul11C2iMJ43N+ytUn6f3z9CK+Rv
         N9GxHArft0OLu70g1FhWu5puiajCHhSzK1XfL9j9aDMzA1o8gEIvLeIE2M551uDy8AAP
         lOdw==
X-Forwarded-Encrypted: i=1; AJvYcCW+/NtSa/RZqM5rgGvHnLxnPAkrA9f2dWbRSz86SNuEl9vrzvLJi9Tluf3VIIoDz65G6RqchOLCIRwp35oHpddEK3FOXL4X90NqAg==
X-Gm-Message-State: AOJu0YyRw49xmVBPFPuMTb+mFfPUnquRd9cANit4KQX0wFKHqxb38/vT
	jPYmWcqMyrBKLhU9rYxh/bmRB/Kug1FcUHmP7uCbw1DHUp+Y6J7W
X-Google-Smtp-Source: AGHT+IHKLF8mOiTCgGupi6zFSGusLpZaBjQXU79nyEKU6ZSrrUicoKdPhpjF+/I75mLNbtuPqnqYKw==
X-Received: by 2002:a05:6870:b253:b0:21f:642:5240 with SMTP id b19-20020a056870b25300b0021f06425240mr12439045oam.31.1709079876864;
        Tue, 27 Feb 2024 16:24:36 -0800 (PST)
Received: from barry-desktop.hub ([2407:7000:8942:5500:e4ad:9b94:2418:969e])
        by smtp.gmail.com with ESMTPSA id y10-20020aa79e0a000000b006e4de4f663asm6523106pfq.193.2024.02.27.16.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 16:24:36 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	fengwei.yin@intel.com,
	ioworker0@gmail.com,
	mm-commits@vger.kernel.org,
	ryan.roberts@arm.com,
	v-songbaohua@oppo.com,
	SeongJae Park <sj@kernel.org>
Subject: Re: + mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch added to mm-unstable branch
Date: Wed, 28 Feb 2024 13:24:13 +1300
Message-Id: <20240228002413.28368-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227173426.BA0FEC433C7@smtp.kernel.org>
References: <20240227173426.BA0FEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

> The patch titled
>     Subject: mm: make folio_pte_batch available outside of mm/memory.c
> has been added to the -mm mm-unstable branch.  Its filename is
>     mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

We got a build issue on NOMMU platform. Can you add the below fix?

From 1f106e7bb72e4957d106f9f9d080599a630cb135 Mon Sep 17 00:00:00 2001
From: Barry Song <v-songbaohua@oppo.com>
Date: Wed, 28 Feb 2024 13:16:17 +1300
Subject: [PATCH] 
 mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch

Fix build on NOMMU platforms
    In file included from .../mm/nommu.c:43:
    .../mm/internal.h: In function '__pte_batch_clear_ignored':
    .../mm/internal.h:98:23: error: implicit declaration of function 'pte_mkclean'; did you mean 'page_mkclean'? [-Werror=implicit-function-declaration]
       98 |                 pte = pte_mkclean(pte);
          |                       ^~~~~~~~~~~
          |                       page_mkclean

Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 mm/internal.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index fa9e2f7db506..4e57680b74e1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -83,6 +83,8 @@ static inline void *folio_raw_mapping(struct folio *folio)
 	return (void *)(mapping & ~PAGE_MAPPING_FLAGS);
 }
 
+#ifdef CONFIG_MMU
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
@@ -172,6 +174,7 @@ static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
 
 	return min(ptep - start_ptep, max_nr);
 }
+#endif /* CONFIG_MMU */
 
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 						int nr_throttled);
-- 
2.34.1

