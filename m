Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EEE8825
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 01:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734312303; cv=none; b=kjWUnftoGyoBZAtzgFXJpQMkP6x04+QdPIgznQfP/5xQrr7KIl+pNC1Rp0DOwcm+IF4pxTzkj8MqsLcyBKl6jQ6pkVYqsjJMyGl5OKTB5aNat+3yb14gFycYc1LxDAOXlxxS/1bsHNWM4x9qhqdVosxwYcw72ZpqlTwSbnBqlV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734312303; c=relaxed/simple;
	bh=uuzh3xrLwWWRGj6e5UUjz6/2x0VV3XWjE4I3LhvweJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q34P8exAjtUIgs9rF3Mau9fZhbtjIMRlhs2YhvtWeZkaSxZf6vv8IKsUM5KTrxP5lxBiBAOouW6e8L+d5IRb9xfWyUFnOBDOUHDkwHO4ngz6cGQ+NUayRCgfC8ZiTWPtYwR9h3xZNj0NySs1srKGEah6UBLDACjmp7Jf2278OaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bT/KN3ZF; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bT/KN3ZF"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ef7733a1dcso657781a91.3
        for <mm-commits@vger.kernel.org>; Sun, 15 Dec 2024 17:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734312301; x=1734917101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuzh3xrLwWWRGj6e5UUjz6/2x0VV3XWjE4I3LhvweJY=;
        b=bT/KN3ZFfdrIp6ZiEACRk/uBjalaE79qH22tgDgmzKJl6KVXd97eO3TMWkC2yJaRws
         2Fu/vlKqDmy0y0j0RNbOBj+i57wz4DspT2f2Cayvjn3Ig4+mQ4zDwD54Hc8lIHFY3B4X
         ycwuEj1z0g5gQ9FLAV5wAenURE92wDPZIXMdK/VS5l8eQQrrAEvllKQhvzyzC4tEvsL5
         YEpno+tuXyiAr7uRGgvG5BUAopPjy1nUeHFNtfyNZvBO2vvC3pfKY/gB7uuj0rHfpXGG
         p2NcsRPpMTDZXQjwsxyh8LQI5BFIeZ3J1vQ2ZsU3JbhPHrMIjnX/7A5erNqvAy+/kMEv
         +hAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734312301; x=1734917101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuzh3xrLwWWRGj6e5UUjz6/2x0VV3XWjE4I3LhvweJY=;
        b=X5kfLrO69Hbjh1p/aY03PuXOdYuZ4b06VQkxth0Owuxi5novtFguCaUPWGmau2VBIw
         YLPt747yr+DcAZ99hlKuNGYVrtTtHfpd5gJ6sezWcnS/zEC8Xrw1IqoA7oYwKg3N1N/b
         VOP2GxOilxvz2kUwLZhTy/NBkCAG9UJ2bc9QEtd8tfH23fRHlRpVsQy8JIAfJoaFWiA7
         cw6OTG7Wxu4qDRjEPW0a3Fm2IERN9ZSRM3ptZnnGBWwfyvB0xQpsz8ogmhw56dQOijTO
         TXvobcCqGDpo9Pp27LQe6G6eA9WpEssIYlFg/7AfpSqK1WLVaCfPS8ErprPsPEPDr40s
         cgYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu9bEN7cGYtZryRli5sBNF9eSInr0hwCYzLoo1Jq1VrFd3U5gV1O1+l0AuWyhbmdK/nFGRbYCM+yio@vger.kernel.org
X-Gm-Message-State: AOJu0YyB8LI/xNTqUK+ecUHEh7MxEI7+7lwIsAmux8J9b3gwxiFqBSAM
	eBMHeW2BBS3d5KHqepAd0dDmjq2zxqlzndBj5AETsPZM8/1BoB8I
X-Gm-Gg: ASbGncuCF2+YPFn0F/Wu3AgNaPGuNTiIys2hIoz7/W6aVMvijiM6Wc6ak2Lj1VEoU2+
	6jZzVNlwaBi+fn0BSXOm/6iHtCuQpoaiuSItyqJaH280GTuUAseSmH6YDiQU7cEpAoVRVAzRne9
	3/Vx1KJftpxTfRp4GCmfOysjhcB1z154peIOQ3MyXstAusFmkcv7PkZhljZCYtGjLeax0GASRAy
	75KUIYORlysKt9sPVWSvITFpmGcy6p7jz1sEZodUmNxIQTF1bxQfkjwub6k
X-Google-Smtp-Source: AGHT+IEsYciV1zWLIHVFyajc7AkyqQ0j+CKdoRtL3UxgdCTdUNTJWm+rBjKwPoJ6Bgfl6niQiQCzsQ==
X-Received: by 2002:a05:6a20:7285:b0:1e1:94e6:db0f with SMTP id adf61e73a8af0-1e1dfe1652fmr7047159637.8.1734312301252;
        Sun, 15 Dec 2024 17:25:01 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918b78e99sm3656091b3a.122.2024.12.15.17.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2024 17:25:00 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Date: Mon, 16 Dec 2024 09:24:54 +0800
Message-Id: <20241216012454.166535-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <ycujhiaogiwqx24m6fsr555tmvj7sjnhsmg5vl4x2p4tnuobkg@74nrwkugcdqf>
References: <ycujhiaogiwqx24m6fsr555tmvj7sjnhsmg5vl4x2p4tnuobkg@74nrwkugcdqf>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> zram recompression will go away soon, I just need to finish my
> old series and send it out.

Ok I got it, if there is no recompression then this patch is not needed.
