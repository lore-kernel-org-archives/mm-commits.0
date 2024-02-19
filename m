Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC9463BF
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708315413; cv=none; b=VnIE8t76tagdK2rM5L1WC/iQh9Xlx8r9iwzwzbOqsFhtgeA+VMmTOuTU+pcaXoNFTjCXzlBPFozU0BJnmDGKB4FxrUIVTWxJVuWfx0txJvNIbNfpTIDsAHP+A4v66skXn00Ibb5lWyEj4EPdVgCTec2pjlCxBzEmCw0LwsfXD1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708315413; c=relaxed/simple;
	bh=I7ihp/wcnKNN3Km8SbFYu6pxA9L2zkLwO+A4Gei045A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1Es2HRpSfaMBmg44+nq/s6JguF/3hoIyl/VsgZSw/docpaRnRsj/fiCdAbZEN3HOpmKTUPIddt8RUwQGRLitH6iz+9AcxiuLyQiWeC6R97iiapjNOzuE22Y7drla8HhHnkS56+l98ZHfwFZ4RpJO6yzpLBHFAegn1zd+OJpLwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g7god1I4; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7god1I4"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d51ba18e1bso40707425ad.0
        for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 20:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708315411; x=1708920211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFw1yFmYO4ou5f1WFseTGOckxuZVbXBWZtWUjjsMHuc=;
        b=g7god1I4oULMYwT/EjDYlEV6fHIvCTI1M9pmLoBClxTfOY3C9NbhQgczp6zS6ti5Pa
         AKIg22iJU0qk9U+ulI7mxNcPEI0ZcGOoiHN2q9mf0i+knGkYbvQjppkL4FCfQO1kbGz7
         7SV2Zpe9dnFOG3t/YZDYXNRgblhdqvq1qCavSdgcsfVF4KDSy8RTV/RlWIOw/V0UvePd
         qE2IUwJLWnRL1TIKTDt7+6YYZARMaUGhz3GCuJksf/5deWEMS1ZV86g20oKLG1F3zW+r
         AGUz6kmrLEoRQjD9ItPNQvGG01HjLrY+WioU0s2AgwNQHC04gl7tu8KF2w14ICvC4GKG
         tXKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708315411; x=1708920211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFw1yFmYO4ou5f1WFseTGOckxuZVbXBWZtWUjjsMHuc=;
        b=JVkScjZL0TUrzh3i3zMnOImvxucNB9n5GbxUMRG2q/Nh4IbZ96iDigJIaI4kYpsvth
         yVWxlVipFoGpjfGwbgUTVzYtvVcry+RvDlYfD9OZl4epR8ziSsgNlcz3MhKr3Zi/q8EN
         oYg0mdKlcPGDh+zsO1WZTRr1c5N6SOwJQz9VvUzlZAEpB1T9CLSoioAGNoGfd4tg9Ux+
         0Cg6G1YzKYNUTf4XVZqIa3bRQEHFu2w4Nu3qY0WSl3m9JsJrokRwu8cr8rEHQWwpoi2K
         bGOD9ZCC5ASgDKdpPZ+B8OAiSoL1ZZWu+z8igKeT0j2sSFLzt5L2G7FWfzzMO8tXI1gh
         ENPA==
X-Forwarded-Encrypted: i=1; AJvYcCUy9lvRmnWayYwvNtpqvmzv7hpbBtCIlmNEcEKebB7m4mkXvlXhEJjt01NBX70MzlqlDe8DHLyU9RSDn2nmKJ15DoaDFjbWFb/rJQ==
X-Gm-Message-State: AOJu0YzGpTP0YIVy2lNXa0NORRbCOggK9nZPKJ928UAkRXYY8OoGrjXI
	6lRX39t5jK8y3Nxzq2fN3ztGOLtR78ZGY22hMvjwUcYZGuVJPGca
X-Google-Smtp-Source: AGHT+IEJ0NT8739UobBJ+QZMrwfWxNfgNHymBCwEMAoj2G6VsJYbR50yqNkGrcotOYgLeFlp16hbgw==
X-Received: by 2002:a17:903:2b07:b0:1dc:14d:4a0e with SMTP id mc7-20020a1709032b0700b001dc014d4a0emr445791plb.69.1708315411483;
        Sun, 18 Feb 2024 20:03:31 -0800 (PST)
Received: from barry-desktop.hub ([2407:7000:8942:5500:1c11:4260:bceb:3224])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090276c600b001db4c89aea5sm3347985plt.158.2024.02.18.20.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Feb 2024 20:03:31 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
X-Google-Original-From: Barry Song <v-songbaohua@oppo.com>
To: herbert@gondor.apana.org.au
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	davem@davemloft.net,
	ddstreet@ieee.org,
	hannes@cmpxchg.org,
	mm-commits@vger.kernel.org,
	nphamcs@gmail.com,
	sjenning@redhat.com,
	v-songbaohua@oppo.com,
	vitaly.wool@konsulko.com,
	yosryahmed@google.com,
	zhouchengming@bytedance.com,
	wangzhou1@hisilicon.com
Subject: Re: + crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch added to mm-unstable branch
Date: Mon, 19 Feb 2024 17:03:17 +1300
Message-Id: <20240219040317.5184-1-v-songbaohua@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZdK4x9J/hhReO6wg@gondor.apana.org.au>
References: <ZdK4x9J/hhReO6wg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

> Hi Andrew:
> 
> Please drop this patch as it should've gone through the crypto
> tree.

Not Andrew, i wrote a note in cover-letter and said zswap was
the direct user for this patch, so it is good to go through
mm. but it's also fine to go through crypto.

> 
> Also per previous discussion, it needs to demonstrate that this
> actually makes a difference in the right direction vs. using the
> scomp interface directly (as opposed to comparing against the
> code-base without this patch as it does right now).

i assume you mean we should compare the below three
1. directly use scomp
2. use acomp with scomp backend w/o this patch
3. use acomp with scomp backend w/ this patch

I would expect 2 is worse, 1 and 3 are basically equal.

But the problem of directly using scomp is that we are losing
the chance to use hardware like intel/qat/qat_common/ and
hisilicon/zip/zip_crypto.c to offload the overhead of
compression/decompression as those drivers have no scomp.
On the other hand, acomp with acomp backend can sometimes
decrease cpu usage especially when PAGE_SIZE is big such
as 64KiB while providing higher performance.

only if scomp is still an open option for those drivers to
support in crypto subsystem, it seems moving to directly
scomp interface is not sensible. as it is closing a door
of offloading compression/decompression unconditionally.

but years ago, i heard zip driver - hisilicon had pushback
while scomp was also implemented as scomp was not welcomed
for a hardware driver?
+Zhou Wang, please correct me if i am wrong on this :-)

i think we can safely go ahead with the coming data to
demonstrate 1 is equal 3 for hardware without acomp
driver?

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/

Thanks
Barry

