Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4FF224882
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828561; cv=none; b=roGnad+0PztiFiHhz6KRvSJnwy9Lwlq/3VoG7rT5Vdp58Vk1Ace3jIyOzzZol8fYGT/nN42oZyTnoOR5JdLrU+Ayk7FmaaPqpJoF14d24QsX/11ER74EHRfUsnAdKr/27NwDYzij/34kpFZ6Z7l5KbY92193o3FpR9pm3+nTJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828561; c=relaxed/simple;
	bh=aMBiVBHPndwAw27izS8eamT4sj1jeKPkjTjg99Gysqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/x9GQX+kAwIkqs8Ri8N/U+5TGgxPV0HEiHvJh70THF3DH6PZY3OVbju88GZJjwNttAoFw4zzDYlkbiOqPJnlYnxTXhojC4wYpiRajC1pYxAWjd7Zg/CNN9pfw0WJAN7WedkercX9mg9LbpcpFEr9CVxUM3Qx3VOUJrPw5eN1Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=hI3rJkhu; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hI3rJkhu"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21f1d4111d4so9043435ad.0
        for <mm-commits@vger.kernel.org>; Wed, 05 Feb 2025 23:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738828559; x=1739433359; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gskRq25HixIZUC0QxM2Q1Go7Ui0oNEsdBrflDxgc54o=;
        b=hI3rJkhuApYIm38TnNYRWDZQcyhY+uZ4QuB8JO6UzdFCdOukW1quFCvV6Mg1s0vrFp
         2IgDP6m8MjqgJNx2XN1Yww5YqA63iCOAKBs4RBSZ8nclSzuXRgSUq3lHP5Z5KdHAUYWO
         bBavBE2049oPFMsOU8ACdFZRb65ATjC51/bWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738828559; x=1739433359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gskRq25HixIZUC0QxM2Q1Go7Ui0oNEsdBrflDxgc54o=;
        b=kcpIKnSGYC4P9vQHNp9NOQxBcpefNxkKpJ9K4Ncz9gl2aLD0RXQoCjdxiWGwEzzNjK
         phkc1MNBQn7Ei8eNa57/IfgFcT9LLevYG7WhYK3pPgry3dTv1fO2nerXJH01PMe/IULR
         QIasqcxQzdpPOYttTaH4F7LRBJZDCdUOzzmgPzhXQw7QCcK5dFLcZRWMbrtIJjfUdokH
         MBoYgn4MAjHxo8jRInBJ9KHFokkBqrI4zsZ8+aGKH8XKWWsiDQDVRJkBZcpa79sxHRO3
         8FQb6whRLtQ2zGwxkHKSGBf/XKGNP/XtO5ahuNsdPmswgKLs/ZXcEYVwu0LslhcFb8yF
         XiGw==
X-Gm-Message-State: AOJu0YyHb3SRF8Vziq+ItMUcKqsG0nxzpCHVblp6/IrKhNQjtXuxMrS4
	3RIx5FOSbKpZ3LPRb2DtfCcu3GoaoArQ0v3TU+2oPXWcmdFkneBXXwhTD0ERZA==
X-Gm-Gg: ASbGnctOfbMx4JdP4KLaL4d0q6cd5G2pLTxsJkQd5lu0tIEHvxsY+QO0GJUQJtBa+Iz
	X3Feig0eECJwli77KogJkhYzA7qm+LzsdRoZClX/0q8tEW/daaoeIYgwTPPhVKSRDJHTrDCmaeY
	A1ovF2mBZG8xKlHTPZtGV/Ixr341pkBFqumLBvHnOff9tkaspuc5g2NZ8ll5D5qIJkwa4JBfKyW
	UILzH2FsW1GxQ7Yxrn7tKKIMTRwZ6f3MNitrjeWqdslVxptCEvFbqMIL8rXnkfd3i2c52YmOQxc
	jyOJBe6FWJnbxLnlk00=
X-Google-Smtp-Source: AGHT+IGURjz6kRhnFtbaaUFmgijmHYMZ+557yxODEI8intHSvjowqta27/INL96Hqt93bFkxTw2RXg==
X-Received: by 2002:a05:6a21:b96:b0:1e1:ca91:b0e3 with SMTP id adf61e73a8af0-1ede88d16dcmr14588367637.36.1738828559455;
        Wed, 05 Feb 2025 23:55:59 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:28ab:cea4:aa8a:127a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51aecd55esm636488a12.29.2025.02.05.23.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:55:59 -0800 (PST)
Date: Thu, 6 Feb 2025 16:55:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zaslonko@linux.ibm.com, 
	sergey.senozhatsky@gmail.com, joe@perches.com, iii@linux.ibm.com, heiko.carstens@de.ibm.com, 
	yury.norov@gmail.com
Subject: Re: + lib-zlib-drop-equal-macro.patch added to mm-nonmm-unstable
 branch
Message-ID: <m6ajpv7kkh7hceli5aoj2rfl2uv4vzzlsllcqntq4er4iefgz4@4i3qlphwm3ve>
References: <20250206074516.0516AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206074516.0516AC4CEDD@smtp.kernel.org>

On (25/02/05 23:45), Andrew Morton wrote:
> From: Yury Norov <yury.norov@gmail.com>
> Subject: lib/zlib: drop EQUAL macro
> Date: Wed, 5 Feb 2025 16:29:32 -0500
> 
> The macro is prehistoric, and only exists to help those readers who don't
> know what memcmp() returns if memory areas differ.  This is pretty well
> documented, so the macro looks excessive.
> 
> Now that the only user of the macro depends on DEBUG_ZLIB config, GCC
> warns about unused macro if the library is built with W=2 against
> defconfig.  So drop it for good.
> 
> Link: https://lkml.kernel.org/r/20250205212933.68695-1-yury.norov@gmail.com
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Cc: Heiko Carsten <heiko.carstens@de.ibm.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

FWIW
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
