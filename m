Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325F101E2
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 21:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716500694; cv=none; b=q3NW5QieFQdSJKapj+bBehhV5gMebzDzL3bpJIA7vSX+5exFYFGqW2HMALzPhyOcrITBS0w7Kentd2G3GCCpDHOupdjPdMYNYxkJW2G1P9YOS+UbtB4okbBe+xkv5pCkxrZ4t7Ke40hyMZxWGAi1ZBdK+gUU2g8skA8BNhb8OMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716500694; c=relaxed/simple;
	bh=UO3uZYZosEhB6VtdYGTDy/gvOhebSSZcHJp46H8HRR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohxux3XTibOoyNe5GwSP6UdaBcolAKYAGxtdjnAvw7wepwzqnmBwLLuEHLcIC9Fdt1ntkTaONxRbsD0MA6qYauszVegOx+XJLrSJNBwafed23OZxbWugsOIQVvu0bIXXn2Ak1AsrLhaO2ETTq3OxQscj/R1/ks/bEGkrTcexD1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjKpR2wh; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjKpR2wh"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-578517c8b49so232633a12.3
        for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 14:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716500690; x=1717105490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmbuAjp9rnghebZfVZOn2Dww4GXQaTcSGbL9U8oEzm0=;
        b=UjKpR2whIMQptW2IVIQjDcAMFJvfotoA0KeNFG/Rmo3u53Ni47khVHtraZbBWe5yyW
         bhY7a16NeM5WDzFZAHYyDPbNgYfP7si4VUvtZG9iR+H3o+9hwzOkvJTkaoVViv1A1zvf
         1BflOsm4Zv0VviMNS4W/8diJUuG4g9wDAiEfkkDHkfBVWsJiJ2PaLyLq9NOHYD2Ins2M
         Kl/Mx683pGGtl2ko98facDRWB4MY2+W3GssXXTpnfojPG2FDXuXYDpu+FLsN6uOmrix4
         on9yCWsygkFur53Y1Ehefn8GxWqGoM4OqF4HEZ8IHAQyCauOFwnxa8Egse0AZ/P+p+7H
         m/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716500690; x=1717105490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmbuAjp9rnghebZfVZOn2Dww4GXQaTcSGbL9U8oEzm0=;
        b=lZthFng4pfHNNo+n7uKb0SQf1Kva4P3Vm/dLRawL0ZpaGAIMlgP6X8oZJJAvK9ryxH
         kUROykdp5tFl1pCmLVA4KW7u6osMTJNaJY+FFy5xQ7kc2MQePZuSolNcOPuAobaPMEDL
         F2z0P/GmuL5Kw9dzBDZRxtdYZ/wg9wnuvv3CmvLYfllN2aITpmXvRCbFuip6/WONnlQh
         g0lLCEpOU7NEVLEpkFxnazuMw7KfYi5dEv3viKCEtq8T2Q2rfBW1DA2BVB8qpPBxiXM7
         gDNccC4c+aMSAQqGLVYK4SnqviNSuZLPSeP0yWY00srYdYynfW2fumvJkn/EUP2aP1EZ
         g3ww==
X-Gm-Message-State: AOJu0YxIcHoHGtuDrhrPB3Yv9TjUUA99YqEJrDgym1177rtoAb4eynZE
	RpECJeKwhsnAVuvMODEP+NVpKwntVmiSLWNHJD5icFgm2AkDqYqww3hRAfgKvGg=
X-Google-Smtp-Source: AGHT+IHzY3aGqMQTBog8y7nrQhND/w2EclAJX44UzcNdj8O4u1OVdjbOylu1O6d3hS5WtYI8GQnaTg==
X-Received: by 2002:a17:906:489b:b0:a59:ca7e:e1f with SMTP id a640c23a62f3a-a62641a4f7cmr32425966b.15.1716500690355;
        Thu, 23 May 2024 14:44:50 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626cc5147dsm14722366b.124.2024.05.23.14.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 14:44:50 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: mm-commits@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nestrov <oleg@redhat.com>
Subject: [PATCH] fork: Use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()-fix
Date: Thu, 23 May 2024 23:43:49 +0200
Message-ID: <20240523214442.21102-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240523211748.GF15163@redhat.com>
References: <20240523211748.GF15163@redhat.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the for loop a bit.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nestrov <oleg@redhat.com>
---
 kernel/fork.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c9e994d66930..f1c16b3dd8ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -207,9 +207,8 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm)
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
 		struct vm_struct *tmp = NULL;
 
-		if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
-			continue;
-		return true;
+		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
+			return true;
 	}
 	return false;
 }
-- 
2.42.0

