Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516A20E6EF
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733997338; cv=none; b=go8hK6POCwonTej3r2y8V3FCPIQf75AYrYtQygGXk0UTfPQb44cZOdS47dMJlnewjH9tcV9XukQNjuxvFVu15pHc14/7oT2LSlJeXhbcyNTCIhP0xbp5NlQjaX+qz+1FLN6gl1jVr9sNRn6GPPcacswzEhZeKKO8A5fr8furNNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733997338; c=relaxed/simple;
	bh=0hixOK5mHYT7tlshC1IvKb3WVyxXdvQR/CNRiLqTUuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kzfqwUBe0azgQB3MxxfKAzrEspWrah7wP9Vmqv7+lvL125b8HHVvnyJlI+ElcTYX/59ntMDnMHhojQBfkEWV+uc61kAeiefm/m/pLYS7X9/f6WcMU2OZdkVjk5oP02BOYS+pbV2JqgH52LcIM4k3w/X1rX3nNJFRNrqh1qmr/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P8wN4N6h; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8wN4N6h"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21634417587so747225ad.3
        for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 01:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733997336; x=1734602136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dyHULr6q4WXhPPiTbnJ+vrhSX4XXAFtt56pGXune1A=;
        b=P8wN4N6hh/cJITuJz0fX7TztCJBP9+NqpKygZoWnp1hW3SWrVqAo7LPTzUi5hSZh5N
         jXaLs8jx3LlPYNxcf9zkmRCpEy6qTcy7L+JyAsnMwnRih3G0ikemtoIoCiqCCrKEcKRK
         sPelZvYcB9EMPgDoubiqng5FZDuBlwmIo05BI6jxAhdIhQAaY8Bv99Ic6K07E0ac7cny
         YbjTjQHKyoaMfnTT/89Af9GEw6M5kst8wr5Nc/ZkbjBGOAvqP/S3zfhDFaFxcBBRqpKm
         1lrlMDKbxaIJw70MoSzPAo7ESHGKChitav+jZquIEMA/xYSikpr3hW+DPHfi+Wj9ePgo
         1ZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733997336; x=1734602136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dyHULr6q4WXhPPiTbnJ+vrhSX4XXAFtt56pGXune1A=;
        b=t0CzJlpnQhVUPm7i8kt9uyLSS6g7JyAmRHue0zIsU5L713zyU+dPl5IuEKwLBJu1Gm
         lpZaTG6rw4jhczTs3tuxF/k9TAP7kXeHUHZVeCqEyhscHb5RTnDjgOPyWvs9VRjdYNTi
         t4HcrcfUwGWuQxpaYNXRedLK+ld24QoZBoa1iJeDuF3fJMCcgEbRNgevmSdO/Ka9NafV
         otr2BneeI+3PvSlM0Dxc5ZVVuml87u3ypb1UvcXa0zrtWzfuuSX2fNwrePwQCGhs/6C3
         y4uvDEIdNnW+lbBb4J0ah3aQqUWkbgjrnRt518ydnwAuG8hn7pbN1RwvihHKlbdk0EJf
         iGhg==
X-Forwarded-Encrypted: i=1; AJvYcCVvITjWiyAqV8LAnW3cMRbiKWNhp3mJDannfr/7vHflVzi/9bp5AwLM+Ykyo7Cwq0FybX3d+XhbCMMN@vger.kernel.org
X-Gm-Message-State: AOJu0YysB0fazEXCVOgi2cSv1XSZOkRFGMeWclRF9TLYkxC5lqfsu1fY
	46aX+yjuMUS5/4EtYXx63sDmhEhfJ1oLxlLEoQIWiJPVh2T7h8Q6qiVADJ1I
X-Gm-Gg: ASbGncs3ULcIXOGNhrxoyREAAb2Xzvu7FzdAz30zWAhRdg3ybP1Cf0pg6uaoJXMO50J
	SH/7EYqlLJzEYqiunM9m7p/2TKy3kuxFpoRNinjHstp6DucAilKcpC3r3YR4jBklrI9+9ps2aAv
	m91W0ErUU6q2aVqmhT3lVqCSe6BgxPxWX9T4LUqCNMD9ZPPq7ghgbVh2FiZKMfHN1fCEBytDY7O
	6jg3lfC+VO53Q1UVFMxgcoZJ9qd3gHSyvcGGS7uyJWKYnnWgR2cPihmN+Xk
X-Google-Smtp-Source: AGHT+IGn5ZvBHFjrOhch5ND5MG3GskZGA85KINV9iZ6sLHP8cNZWUddgkNLbImPfgIhG7+W78SwFTA==
X-Received: by 2002:a17:902:ecd2:b0:20c:da9a:d5b9 with SMTP id d9443c01a7336-217783abe34mr35945845ad.5.1733997336498;
        Thu, 12 Dec 2024 01:55:36 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f12b23fb7asm2272100a91.0.2024.12.12.01.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 01:55:36 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Date: Thu, 12 Dec 2024 17:55:30 +0800
Message-Id: <20241212095530.162164-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241211110414.GF2091455@google.com>
References: <20241211110414.GF2091455@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I see that somebody posted something similar on the bugzilla [1].  Is
> that person you, by any chance?  If so, can you please post your
> findings to linux kernel mailing list? E.g. linux-ext4@, Cc-ing
> linux-fsdevevl@ and linux-mm@ would be a good start.  Bugzilla is
> not used.
> 
> If this problem is in ext4 then I'd really prefer to address it there and
> drop this patch from zram, simply because it covers an issue in the upper
> layer.  And it's better to fix issues that to cover them.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=219548

He is my colleague, he reported a bug, but no solution has been found yet.
In any case, zram should ensure that its data is not damaged, and not rechecking 
the length after recompression will cause more serious consequences.
