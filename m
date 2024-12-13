Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89836F30F
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 05:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734069401; cv=none; b=ooUlx7HsJMBDcUUk3d8WOX9CCkyme3OqRsdvIKwkOlJAIT4ye++031o1Z6BCJLL22a2N5ayYgI8rwpIGKimTOv3oss7BmC9GYGR32rPWwOkz18/zmo0Vi4JcCkNiQiBOwJEW1maAZGuAdU00hd0sic+pRe91WzubIdwlz/+lR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734069401; c=relaxed/simple;
	bh=MKHg3mBnTwzwpY6Vjk1x9IP3qeRMtfj5sDx5y+a+noc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSDHQPTtELuSrIYC1ivL7U3HAO4B8WHixLfMwncYtazTHMIsAI55h3IADYfKyu+yh0AFo9MwC1e6y7zgZ7f0qL66lloxPa1M3x/W8HcY7A4yj92XYVZrrU+RBd4YTXopX3GQ/pZsEbN+omo5Uq+iyWXL8JoTId1g9DFThee39bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dm7STScb; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dm7STScb"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-215e2f17dfcso2225565ad.2
        for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 21:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734069399; x=1734674199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z28XVisFV3DgPWLWYjxK6NzmSsUs6T+jyXVcX7RX7Ug=;
        b=dm7STScbmVomqsLW4Xpa+cY57GdpvN4JzmYwloiMZCXBzat0ppnh7PynU8PBkw2kWK
         wvfhVKlpk2gKOx36VZRoXC7K6Mo+q20my/Xmiu8FqyktPByolRJRn7xuQHZPw8iSonMG
         MVFW+IwMXNMqkQhK4xOcMlZPmMQkWE1XB8wotzAi50HhNIOI1icjsWQWTHty+0MmA5kZ
         SWmkfNSfaWQ3bIVZQIaaS+Y3U9LPaZTKs+pnunZjRszguSmmyjApUryaBiFcjcap5OJU
         j536J8SQ3UI5BiGRFFkUcoULA0A5r4QLdTQbdTxlu+ajRpho2TQ8uI06HwcFUbFkBFrH
         Irgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734069399; x=1734674199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z28XVisFV3DgPWLWYjxK6NzmSsUs6T+jyXVcX7RX7Ug=;
        b=GuYPdvFpzQefNTWRrJfcRi2D/rThcXOHaZ3XxGJgIxDRh7ZzePricDoII7h59bJOFy
         f+wMppaPajgy+enoHV421L+y/gKB8J4NvXgUGOmdRiNSUwaJlF74hBm3N/TO0Tt5VPS7
         kYwKAl4akWWR3TaO30+gzpVixrxj8hegg7QfBVet0nAEcnVwUCMgky+2yewp998Y+aZS
         d4J0OXeKgu/mWojN1TpzU/bQ3mVZ0sfyAgEMl4QY/VAZJUyBnH9ulqx0QJW41poYxJhA
         /59SIaDk4yk/WobUib+AhkOHY+nwgY4/zYhO0pQZ+XcJdA7PAvtQ+Y0lqK/T55EeVaZT
         QUWw==
X-Forwarded-Encrypted: i=1; AJvYcCU79EyGIM0Big4H6vz4DvibXKwPPUfdyoobFMVAwnYhGRavZDUfbgEcdTsHUGXCihjAufEl27SSwFar@vger.kernel.org
X-Gm-Message-State: AOJu0YzzsBQYnbpZmm2c31597Vq5A4kKslgoGQvABLYtL1FHnaga0Oxo
	I3MqX03OyEG+Ci/FCRB1rpAVvQJqN60EDDBNt0Gs8QeylEbIxi/h
X-Gm-Gg: ASbGnctSt/9bMqR9y3szbPHIfnQhu33ba2YPHiNYS3ZpmEBuVPTpIcyFISs0zhq73dZ
	dNzqgaC6ZMolU2vLRibIuzhsj0igVetoijFqI9rUib4CQ71eeKQTWGrHC3JP+meYhk9uwwmLI4Q
	GlylRAChzm/6qaTAlpdzApuntqqHeVrN1uVis0V49i0jDycqoAXtuhWMV5cusDYfTTSfWLiUc8r
	Vfgya3s5ew44FXMyl4lESE5RmD6zX6y0Uj/I+xLuQX1H+lSq0Qpfqw9dobh
X-Google-Smtp-Source: AGHT+IEffIDODZ5httXbUwfG/ZRIYYq17d+t8dtTr1FTHqEWJlg9awsyk/Cka4GQM0K6YeRJP+TQHQ==
X-Received: by 2002:a17:90a:e70f:b0:2ee:6a70:c5d1 with SMTP id 98e67ed59e1d1-2f28fb5dbdfmr935372a91.3.1734069399190;
        Thu, 12 Dec 2024 21:56:39 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f142daea53sm2332972a91.14.2024.12.12.21.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 21:56:37 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Date: Fri, 13 Dec 2024 13:56:30 +0800
Message-Id: <20241213055630.163185-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <5qmps6mcifydwtnsynxdtipaoerjrnjlpo6gztxfdryn37bvws@fp2xqjmiews5>
References: <5qmps6mcifydwtnsynxdtipaoerjrnjlpo6gztxfdryn37bvws@fp2xqjmiews5>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > In any case, zram should ensure that its data is not damaged
> 
> zram cannot ensure that, it's not zram's job.  Nothing stops
> the buggy actor from modifiying the page at any random point,
> zram might not even be able to decompress the page in the end,
> it's not only the zs_handle allocation slow-path case.

What I mean is that if the length after recompression is longer than before,
writing directly to zs_obj will cause the next zs_obj to be corrupted,
eventually leading to panic. zram must ensure that its own zs_obj will not be
written to overflow, not page.
