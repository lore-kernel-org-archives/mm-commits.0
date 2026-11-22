Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359223;
	b=ESrc6C8KFfDFLVJ8sXGi4MleSsxGJEPDQZRlROklqDHSy+9kWYhwGOBJFPYKNSarm0y2
	 RUs9ts0koKCjcbfkTwCi6T6A+oKFZ4IylEhmJtxtmsb4xV9UdlQ8ePL4sThipRatxsUhy
	 ujOVHijXjuoHtD7zUJKzh8+O4Jnb3mw8JaJV/QeGepTDBGChsxLMXest9upr1twkLwBja
	 QlRPSin74ZrYNQc9R1cB59U3RG1zPt6qv8qhvyuBvExP7qw9iuk+9tYt8sWCdaEzvMV9h
	 +Wua6kdjSc33gYy1IEBljpuyb/I9JLPjG7ITwZjZS6bPCWrAmCBqHCp31v/61/JwUnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:Date:
	 Message-Id:To:Cc:In-Reply-To:References:X-Mailer;
	bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
	b=KfbGxcg8GjWQZS01YHyO6Kb9dQmyMwZPTH5+i5zn28cz7RLTIeax0rydQjHMBpPeAICl
	 cgvPnLaeRVYka3BXdmY3PRXhb5BYmyuo7IRoFwAXKIMJzPNtk4p7KxCK0BmsTgjKNXjfq
	 ApC210KGqUSvIJThmJRJU9f0Gzsy5/2DVR8VGBuL5+6h43bVoBpp4Xxz6ZzgzDtmispZb
	 jzzvQYr+7nYKARAQK07dyqYIhyW3LEVdNbCEXgKC1CfS3yxAnssMg3rAQ2c8M8XpIjsLO
	 O2JqwXJj9pF6pddql2ToEUaagGNuHCOhiZxSyMgkBv/BPF6JD+2nvml+Cu+KZ4nKMJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rB+Fu4J8;
	arc=none smtp.remote-ip=74.125.227.132
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D5606A32A
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 14:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C30D5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rB+Fu4J8
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3b497279c25so39640a91.0
        for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 06:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795359222; x=1795964022; darn=vger.kernel.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
        b=rB+Fu4J8PRCHdsRpQdHo3CD3HVntEncnLqumTBmdgp9V0ixAvzirDoaXw6nsGK/Sz2
         dx9kPJNY/9Ubx5IxzgdR36DPnCBSbgewi33uYn3ihJT2LD1kALU3hRP/IJKAB4X9EUrf
         IGNwACUVWwQ0YAEUESnCB+QG6LWn0B33+3K+Q+L5q3rEZB53NE9f9D7qI6DE6+LlPCME
         3nY14TLtlUW8EwFT9GxwGjuq+MnE8zXcgWGNHxlannh1OhNnHV+LWuhbUMSG6R4ScOJu
         xJ/JHsIKm4SpUrO7nzE6eAfa0ZJQNvcYNPg0r1buJIBc2NlhC5/n9qtpq9VdwzRqNy/0
         8jvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795359222; x=1795964022;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
        b=lCqDrDaoxuuuKPpC/GCOyhaVQfTpthZIXDfGlrvYnIw7px8kZhKWYZxop4uIM8Bn2h
         pxicGSyvtyas9fWIXtmqorI8JQCJbVPxYduFcoyva8VGtPuPEt83LFWJNqIcIxzZ3OhX
         o+3f0SD+HuH2C6pftwkckPJ9sGWcV8Y6Vl43w4wjENoAgwX0+gFgVpQn4uTuTHOPog5m
         JhX3E+ZEAPTUgU7NwkdYHiiZngj/omHb5c+dMzLkLWhP0h20IY7m8eEpAfsUyZz3x9Lg
         hoMoJKfIMhuIoLV0Y7tJkwnCpF0/GRgxkTBA/uomf3KxZJfY0w+nzRA5GngoCcDRTrdG
         Labg==
X-Forwarded-Encrypted: i=1; AL+hErF4xP7WVczEwKxFOgOvbAPjTnxYVh2Jel3YD8uButn6mz88S+9EWzv/Melm1llP+8U7KbKPCv6OYlMK@vger.kernel.org
X-Gm-Message-State: APuU4Z9QSBbFHeB9sn2PgOQaJm1LcOldFVe8jwHDR0h4C+lBPEB9mkrI
	WWBQmZwBiINjCySchFjKwMZX0Ea0w5dqDa4cGWPWSlUMF/BXu45KuVZG
X-Gm-Gg: AZFdTZdUrqg4YQYwi5EPgqBlRruDM6uVZR9VTgzqg63hUxuOto3w4IGHu/YChuGjhlF
	vNC7MEUrGQ/UpF8RMJr4lPx+zJ99ep3zvd96EXNX/7R5C1Ue/r1tBSS0emWsxsbOd6Hpwy9BNq4
	hTbHJHjoa6rgePjbUMfW9x3N1RCmDEe7yLOaEwNSDKCmyj7q6kDBRpvyOpn/rFTmzKuFTTivjHM
	3NXF23+FkstKWXnL/6YuAlomyfIHSgBff5xLFB9FJrXX69qLvTVr8p7Y8JuNtU3SQxKsZC09Ec5
	eKfRfyJiu36BgVpp2CnBXmj9Epx79sIY6L8hETblNnzQgLt33d8ueHSgkR+K33OsCsG0/ow5Bu4
	b4AO4NOSlofyfhfbppeI7nMRmPKGiohZZflx//PbcZjfQKNisNgdlyLe377sb69z5gmtI4xi+Aq
	pBTiOHVI2Tvlg2J8KHa4xxnCNOguJnMeGzER4XDMviD9WrZfWfjoziK4C1alKOFxwq3L0q6HQYV
	WhhTjRtnLyc/rwG+F7Agy7+WJxMDQ00vWwx2Krcai1KhhpdvxHMZ1CaXvxN/5QfhQYg1fYyaW//
	S7UdaHIIRF5306WH5U3rLdpVE3HInHUEd7kfGYSYSacyiqdR1bd5xbkohJm2Kwu8/duRb3PNjJi
	Wo8g49oPCWUY9BYtftXZ6ClN12L/BEQ7bW93SMTZyIfvgKnbB8ctTK7G8wfZUHPEviJkK9W0=
X-Received: by 2002:a17:90b:3d4d:b0:3ab:36c4:b502 with SMTP id 98e67ed59e1d1-3b41c90329emr8542890a91.30.1795359222086;
        Sun, 22 Nov 2026 06:53:42 -0800 (PST)
Received: from [10.131.38.181] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b75f2a4sm4545959a91.2.2026.11.22.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 06:53:41 -0800 (PST)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 01:45:21 +1100
Message-Id: <179535872126.34.4789080961796247940.b4-reply@b4>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com, 
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, 
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org, 
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>, 
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com, 
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
In-Reply-To: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
X-Mailer: b4 0.16.0

Hi Andrew,

On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:

> Store the corresponding RAM backing page instead.

This avoids the oops on the first read through the second descriptor,
but leaves a stale backing page pointer after CPU faultback.

Since the mirror XArray entries don't take a page reference, they rely
on invalidation.  When the CPU later faults the page back to RAM,
dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
migrating descriptor's entry before the backing folio is freed.  The
second descriptor still points to that freed backing page.

Reading the same page again through the second descriptor in QEMU
triggers a KASAN use-after-free in dmirror_do_read(), and the read
returns the stale data instead of what the CPU wrote.

The second descriptor's entry probably needs to be invalidated before
the backing page is freed, and it'd be nice to cover a second read
after faultback in the selftest too.

Thanks,
Aveline Noir
