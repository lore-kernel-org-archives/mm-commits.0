Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623708BE5
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 03:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720755022; cv=none; b=NlRkDIVWtvMdUW67UQIma0ozya0XGbc92OWme7IWR3fM/OiTTsgu1psg5FzETpnfBlbTC0q4N9PxVvqMY25jahA0o05KTltA0ngJ9SHndgsX/YrIcComDQOSnnJw4sObFLOKhfG9H1aN524plaaMAzKHzirjkvzpvI9odaGPr2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720755022; c=relaxed/simple;
	bh=OeWf5hpYet/RbXlkzc331DMP5yK1vXx8T/UOanRR9LU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=LANi6DnhPxhWjizGOpFi/K+Pkmo8ttP09y7tjUFkbPjnIfXnHOdR+OAY64zJm6JJwIojRkyO9zXiJ3TF3++CHABjrcCBjmnOl4SaTYmpEB1+L8tEI41HrrP+lYipaeoRwcpYhoQxlxWQFD9DiovhVxgRorDrg/KWas6xcPHjuOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VCEurgKi; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VCEurgKi"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-64f4fb6ce65so14738227b3.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 20:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720755020; x=1721359820; darn=vger.kernel.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OeWf5hpYet/RbXlkzc331DMP5yK1vXx8T/UOanRR9LU=;
        b=VCEurgKiAOnZssmHslbhlVvWML9I9yi6wTEH2eUB7OSDA5P5DzZkmFwX9ZjCOfBhtV
         XFYxzl0gCmgqY8g3o2q3VD4wnwSo5S3M4YTM0FIioJL4FY6kJcg/KKW0mmmQxmUPQ1nX
         MD9EXJ3AZQ3Yrg6A0IL6aCRDlbk6jtdwRJKW7JC3Gc25Q0Hp0dw7qUDncA2hJi1viil8
         VjmSDC1jtsxDf5k9a4qEtD0D6GrNmfhzeN0ThA/s/L07Amt9Gzw5gcWNgGyUaO70UpjY
         sSQ4ORhCrttFclFLEqoW6Yx4fLWqlf23yPlPN4bcY9Sk16zBw4JCYV8F6pdvz+X80/O1
         dQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720755020; x=1721359820;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OeWf5hpYet/RbXlkzc331DMP5yK1vXx8T/UOanRR9LU=;
        b=A3r8gJJMDObiBiAsOOuRX1Aoo+tWq9w0vzr464925Jw5YD8eBq6CMBkvdCP1IIDEgj
         zFuZpamCtHe3A4DChZxDDPuveVH92FYL9rk6YXRqx6iN17Idkcjibcoy2cPoBDYSlvOC
         fC/ORtqOdHiYIa0xof7yPflHuPOjNEzaBxQuN1uO64njuLZ7tPIa3qROjc4lb7XYPTev
         AUnUALXnqJeaJmiSTGdb2B7YPixjGiiEvkh938A8nNpKmcLkYRpJkH7cxZLAK8r142Bj
         RqY9fX5JoAAF2bzqynL+Dkj6ciSUJSyX8hCpGN90Yp6WxvdqkWGdGmxVoeCGR61ptfb2
         S3MA==
X-Forwarded-Encrypted: i=1; AJvYcCUPmDGWkPv9uZnluNLBh/RtYXceZS8hSLokJXemOpTpKFadbfncjdm1hWqQc57C+whhgZpsUdPQrEoHBaey3LAKMHl64QRjLAIlWQ==
X-Gm-Message-State: AOJu0YzLsNoMpfJReaNfTEexEXjTRhVJU7A+8fDDp0iBSPDHeZe8DlpI
	IlCybE+6gfRYe0vwExg3FZRtTh4veOVqBxAbuclVbo+mDuFKj4Pt3G8dRZbVeQ==
X-Google-Smtp-Source: AGHT+IHRcI3zLY5dVsNwDBkTyC6QESRbVcQLpA9Z30zixEAJepe1gj3fHYLSPfFRKl2iEkFn+q3leA==
X-Received: by 2002:a81:4406:0:b0:65b:a403:9ec8 with SMTP id 00721157ae682-65ba403a076mr67878437b3.38.1720755020169;
        Thu, 11 Jul 2024 20:30:20 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-658e4d2b199sm13516247b3.43.2024.07.11.20.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 20:30:19 -0700 (PDT)
Date: Thu, 11 Jul 2024 20:30:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Aristeu Rozanski <aris@redhat.com>, 
    Chengming Zhou <chengming.zhou@linux.dev>, Hugh Dickins <hughd@google.com>, 
    mm-commits@vger.kernel.org
Subject: mm.git: a small error in mm-stable
Message-ID: <85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

In looking through a "git log -p --reverse v6.10-rc6..HEAD"
of mm-everything, I just noticed a small anomaly in mm-stable:
ac90c56bbd73 "mm/ksm: refactor out try_to_merge_with_zero_page()"
modifies mm/hugetlb.c! undoing a oneliner which had been folded-merged into
003af997c8a9 "hugetlb: force allocating surplus hugepages on mempolicy allowed nodes"
which comes just before it.

Hugh
