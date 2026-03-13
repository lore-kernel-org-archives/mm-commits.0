Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53363BED7F
	for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418009; cv=none; b=aN4b63y8mHLxEaA4gOPV68pbvDONuvAOlOq4HZmKngdICHbKzLYbPj9fGGUbqGgQK6EESliWupdBpzg1Kqw+uFNYl0mMDCeTkDN+/M06qI3LeU+iWjx2cVjbgg7p9rNn6gDHNgBS8j6DuZDuFL2Wra7TudLr0RSY0oP/V31SijQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418009; c=relaxed/simple;
	bh=mrgB6OYq5fl6la156FZGEjM8+cGmsWQazLL+9mA/3YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uctj/ffIbGCtdD4z8xY1KIVz7KZUl6HD/biR9tMsz5z3/X41Ojw5sk7KzSY2IqlXKexb0yA5P4uA+kJoMXoblvgRnavbD6ibFg6IG/4LeQNhYYKLT6xTak+J9C0/P1swtnv1wvnUCfRtg0IrrxF7PavUkqNneFRSkQunSiebod0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=16zJbp0A; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="16zJbp0A"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-67bb5e4cf7eso1253934eaf.2
        for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 09:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773418007; x=1774022807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIGUjW2HEf5IAtuw8pLHFD1v6D6psz7Cx6Shlu3igSk=;
        b=16zJbp0ACT8RrIF2FoehxWQzpwxTRXPKVzfMIAgUGQ12zsW/H9XIfhff7ecLpkYKp4
         Dg6aGzY4WuPb/bpEs8PE7Orb/wbWsbqUPOYynPqx002QSDAfz7ff0hhQGLgLrIa4+Xys
         ZYxXkuN038Eh0M/4Okpg3uyTXtK5Jqvsars9HPGTYSxVqjAbwHhNlPMyJhml4E00q/Dd
         HzEDdpK82ZGzwvZXFgpNRWrcpwNmm+LHHTwxHljz+PyQKE/bbvbwZgEW/ZCD5RMtQfNU
         DR8sMYKEyjSYS9pSreA+/bhyAriD1SomiKBbp8vVLJ5aARG26ob3Eydq3LCYIK9SILdp
         gl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773418007; x=1774022807;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIGUjW2HEf5IAtuw8pLHFD1v6D6psz7Cx6Shlu3igSk=;
        b=e4+jlpVZJK40SYnnrRMLbJHDALhI1J16hmbdKhtc14LQN4uCG3qf4QjDN6E+zsoDYO
         INwCU4gjDBjtKbeejEGs7MyjKT9DGpC9Wc/bE9kA2GHuJDple9Z+Ce3lx9dJHewVDqil
         S0HygLfNq6039W53Qqatogz/cV98IjfSE6Id+OojlqlGNXH4TsRsf2pL/+S5HhXv1UfP
         GuYl1e5EGzBINuyjYA2V50lYYP7wT5eZEAiWhpqHZgIv//+tqyfyUOq3KwbZbVTLXUao
         ldj7XULquoT+Cr8hSsEjVUASOvq/BB1B8j/id5LPOsYdEY2dF3Ko7xwmuah3jbmkP7Lt
         1KUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVzQDRV9ni0N0eAlJzjkCSj9unc4zHZ9WbjNb0pOSYrfUQUbqbNAktYszvbjQxWTjaOwJrkLjRC8sG@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp4MrZ/yti+xt0C2gUS1EKEwh+tjG/F8h0ZbvM8gxAyWc5OToX
	JI2jrBEjwfQkqLSE/VeBI2GhMOV5XZ5EYast/Hyw0zwlXL4v93V75frnsuS8wOwQp9U=
X-Gm-Gg: ATEYQzz0ciGO4uMxnzI6BKJKOK4aElEfBYVJ47YiT1CQDf5aVhqcbbLE6ifKsCEP0Lv
	ohEGGcThB9PZggFAjLSq+C3l4tL3RVrLtRMjJqNMJrFfLKX4MlIIbxs9yHCeJpQYO3dOE+k+Y7H
	ucfOeYJ7JAaPSuZL70zwTY6+glJepCGNKWKyg2vNG4KXJoOS83M+zmbNFjtqMuT42MQeDqgf+dr
	7n4rFgh0UaOEO61cfCw2pUkcpmgiiaKJDVd/gSwI2/oRhwkntvfmhTGR62qfpsrBYcOz80UJ1gp
	95Bf3PWVb6tLaGVbS3Yd1/bvXSp2KyOQCppXtyOEc3GivoyMyk7d/hNr0i9O4CS5X4vhxRmpmci
	aRwoiAZC8rA22K1basrSpX6SV/h9iPLtyQ7FNETN4ta4JtDJH0EOT2NhLfMaPt3Ky1LBpi8BjHe
	+YBDcVMO8kGuRrpKATDZhzFbZWNPxLoUtDulmp8tnIWaLu32ANmeTYbiLophk7DBA4VpYH97CwX
	nhTaHbE2A==
X-Received: by 2002:a4a:d312:0:b0:67b:dd84:2798 with SMTP id 006d021491bc7-67bdd842e6cmr1168312eaf.57.1773418006742;
        Fri, 13 Mar 2026 09:06:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc9307b4esm4858249eaf.11.2026.03.13.09.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 09:06:45 -0700 (PDT)
Message-ID: <9d8205fe-c788-429a-985b-8472217dbe32@kernel.dk>
Date: Fri, 13 Mar 2026 10:06:44 -0600
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
To: Josh Law <hlcj1234567@gmail.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Vlastimil Babka <vbabka@suse.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Josh Law <objecting@objecting.org>, mm-commits@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, "David Hildenbrand (Arm)"
 <david@kernel.org>
References: <20260307221931.2848601-1-objecting@objecting.org>
 <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local>
 <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com>
 <20260307222154.2848660-1-objecting@objecting.org>
 <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>
 <20260313-anvisiert-gemeckert-352414e3d58d@brauner>
 <20260313-halskette-annahme-94e782eb4ae4@brauner>
 <01a6bbcc-1442-48c7-be5b-14f07fe655c9@lucifer.local>
 <28175752-2775-476d-9485-499335a99aea@gmail.com>
 <e2278198-22a4-402d-9179-c7cbbb186d5a@kernel.dk>
 <8bc3ea9f-4e56-4e41-8cf6-97e3b5a45b31@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <8bc3ea9f-4e56-4e41-8cf6-97e3b5a45b31@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/26 10:00 AM, Josh Law wrote:
> Thank you guys for the context and the history. I understand now why
> my request was premature and how it looks from a security and
> procedural standpoint. I appreciate you taking the time to explain the
> 'Jia Tan' caution, it makes total sense why the bar is so high.
> 
> I'm going to take the 'no rush' advice to heart. I'll focus on the
> technical work, learn the etiquette, and prove myself through quality
> contributions over time. Thank you for not being super mad

That is the way! Just keep at it, it's a long road.

-- 
Jens Axboe
