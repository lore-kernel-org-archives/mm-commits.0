Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CAF1E04BE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738170910; cv=none; b=t3tuu88gdBx56BgLVA3SjF6LVEuRPtIg4sr6k/R8wPhOZs/zIIGAyxtbbmfkxkkp6S9b6M0LXNrZbsF4b32AAI04UpqGw6LD8LO59qZIIHdyiDsWon6Pk5kIh6bSci+SnSMz59imk6r0AfMUC5rAWGSmFIL6/n//UtG9VDz52Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738170910; c=relaxed/simple;
	bh=CGO/f4Bac8C2gpxKd2TWti31NdBiF1wDjsLwWPvKspc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ck1g2iDxRUfF+ndtqBNyAsFsTEph66NzDdmKnU1E3JXKmhoMdLlp+ojmoTPzwVYJaXuwo/SOl5f5phKE01qFb4rIIHspTTmHxd3jZsDXNotXqlhlNk0qD7LTiGjoSXr6dK3qAfeQ0cWYva9usb+Uq4GqPKwyG/qpPD4Yh4Yg/iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GNrWIVfk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNrWIVfk"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21625b4f978so307065ad.0
        for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 09:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738170908; x=1738775708; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9gH+YSZ1zmMCHSxiUQyhq1Bw/glWnnyFqEqhQoLAovA=;
        b=GNrWIVfk4VNIBYDM0EDJ4/gYP1IPQeJ/+uUIEnKv8tatyOFBb1SpGzSXGqGqkTAlmL
         vdPgbfUj9jg9ZUjIuoAm+ey4/0Hot/BfspwoIgXQq2+Oi7gDNs6dpoRn5nxA5Y2IHLkI
         tenggLNFkvsN3DXESZOWQjWFjs2MdSC3WhMAGxJXgxxIuvPrz//QJpQyb45EZzD3j/rz
         EgmJOMBquDTaRuVJWF/RJHVH2sflwIMGA+ELvz9X7v+u2ypPm1QpoURNeBtgk8eNPqGY
         0gL/7L2J4JLrkMjR54vTMcFqkww5A9ccsU+gmutzWGRCjRaKyJ6Fua0nAEcasbAdUSo3
         NflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738170908; x=1738775708;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9gH+YSZ1zmMCHSxiUQyhq1Bw/glWnnyFqEqhQoLAovA=;
        b=ugOv5OmpkF+GMF+/WSREwpTN1hhjYYgEHWfNmN2KkF9vb9RN7aIfeEOg2WYwESAC75
         UoiLD58jSA7Va4Yoes6w48TftSHRxDr05jRa1O+DPqqqeqwoifEKzu/Ffrdet9jf0+FI
         Iv7QdMKtQ/kdwhk+X0ycCI2eZqK2JpLO0aXEaTumso9LpxGvYjUR9U0PD6kdff+nKnBJ
         C2Mm70TBnsnusMdpJkZo+f65XjCxjLflPm2FQjme4u6mKW7Qh1IXvWjjp30PcbbF6Y4v
         MSFEvJLd4PMTHwErwRnAsxVC2uNE6Ylrs4WeTFGw3Xtif7X+0OMzN/YLAOuO+7STz29D
         42gA==
X-Gm-Message-State: AOJu0YwD5UkGWCgsM1PR5TqCwTONbweAtZ+23JD+DOYU5F50BxnakAIt
	GuYrN2BbZUSH7cKrdgrHAJa/lxIGKwi/GfKf/ro1PvW5XPPcR/G4Kcf9Q00S5w==
X-Gm-Gg: ASbGnctyBYyzURaG8M5ALN0v61ZbpxIfqHg9F89aZvehQrcMIiIZhuL9qpvijKuUoHD
	5LCWibSyII7sohct90fHOkk/8OQOR3WBxb8ny5VcZ+3n5u6F9F8Miv0Qz/mJGbodaJ8SiU2HkMN
	uSrhZqDeivqjwibrLTOqNC0yTZFBaLcQL1L63ScqqHbaIB8szRW5HvO+ynbghHWPN3gtEBmOK/f
	rOHsUyY1BiOtQHyVzLscAVtG6R0+YWcPdPEEXyvZq02I/gbAYznkrwTPmdcFsHnm1mjtFvJFDgi
	Rey1NCauOnOq0MpPXAnx6mXM8pGFKAgh4/JB7C1jfWU=
X-Google-Smtp-Source: AGHT+IHbIimiAIsjiZVjX02mLBsPolVm2/N+ESrZ6+rKVYwZe4bSzSkhdFaivEyQUxfWmnKTr6Hlvg==
X-Received: by 2002:a17:903:950:b0:215:9ab0:402 with SMTP id d9443c01a7336-21dd809407fmr2972885ad.18.1738170907700;
        Wed, 29 Jan 2025 09:15:07 -0800 (PST)
Received: from [2620:0:1008:15:39d6:5c4:c4b3:d929] ([2620:0:1008:15:39d6:5c4:c4b3:d929])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6a002csm11524739b3a.21.2025.01.29.09.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 09:15:06 -0800 (PST)
Date: Wed, 29 Jan 2025 09:15:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, 
    sourabhjain@linux.ibm.com, pavrampu@linux.ibm.com, muchun.song@linux.dev, 
    luizcap@redhat.com, gang.li@linux.dev, donettom@linux.ibm.com, 
    daniel.m.jordan@oracle.com, ritesh.list@gmail.com
Subject: Re: + mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch
 added to mm-hotfixes-unstable branch
In-Reply-To: <20250129042805.E4770C4CED3@smtp.kernel.org>
Message-ID: <c2cf3b8f-41f9-fff6-4e9e-1999be619345@google.com>
References: <20250129042805.E4770C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 Jan 2025, Andrew Morton wrote:

> From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Subject: mm/hugetlb: fix hugepage allocation for interleaved memory nodes
> Date: Sat, 11 Jan 2025 16:36:55 +0530
> 
> gather_bootmem_prealloc() assumes the start nid as 0 and size as
> num_node_state(N_MEMORY).  That means in case if memory attached numa
> nodes are interleaved, then gather_bootmem_prealloc_parallel() will fail
> to scan few of these nodes.
> 
> Since memory attached numa nodes can be interleaved in any fashion, hence
> ensure that the current code checks for all numa node ids
> (.size = nr_node_ids). Let's still keep max_threads as N_MEMORY, so that
> it can distributes all nr_node_ids among the these many no. threads.
> 
> e.g. qemu cmdline
> ========================
> numa_cmd="-numa node,nodeid=1,memdev=mem1,cpus=2-3 -numa node,nodeid=0,cpus=0-1 -numa dist,src=0,dst=1,val=20"
> mem_cmd="-object memory-backend-ram,id=mem1,size=16G"
> 
> w/o this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
> ==========================
> ~ # cat /proc/meminfo  |grep -i huge
> AnonHugePages:         0 kB
> ShmemHugePages:        0 kB
> FileHugePages:         0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:    1048576 kB
> Hugetlb:               0 kB
> 
> with this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
> ===========================
> ~ # cat /proc/meminfo |grep -i huge
> AnonHugePages:         0 kB
> ShmemHugePages:        0 kB
> FileHugePages:         0 kB
> HugePages_Total:       2
> HugePages_Free:        2
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:    1048576 kB
> Hugetlb:         2097152 kB
> 
> Link: https://lkml.kernel.org/r/f8d8dad3a5471d284f54185f65d575a6aaab692b.1736592534.git.ritesh.list@gmail.com
> Fixes: b78b27d02930 ("hugetlb: parallelize 1G hugetlb initialization")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Reported-by: Pavithra Prakash <pavrampu@linux.ibm.com>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Gang Li <gang.li@linux.dev>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
