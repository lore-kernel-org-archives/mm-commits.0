Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E0B36C5B5
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773089672; cv=none; b=VWf8Pw7U/6OSv+/A+joe0ewMsGMMmaLBJJPILQG3hZYQMlBPwFw3/KuHptJxM3DYC0pIWXF6lw5L0agwd8u6WTUdtQZfQ3ixcuPJ6DeqSWc/jf+84BWKtlVx8zIbuhazHljCFthhndrbNBzKR2liisHHl4jPs5h7Ns83wpmAzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773089672; c=relaxed/simple;
	bh=QdEZDCxEKJGJPro1MUUYhPOSzgUf3ELdzp1FgkKvc0s=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=DGyLvoe3pyEV0WR3jAfoIWF8iUP0Tw6UVu5rphmgOzxd26GyQYlHeHDzoASl0dtozYKr+SjAPXFU5yIqVgR4mAd1xePMvnS8/ssemx7gPpS3wN81p4w//ES6bjIBDG9cCiolmktFP5FtBvU+bYFexZqV+pkwx6wCff6utKu7GRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idtKQnvk; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idtKQnvk"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439b790af67so5056532f8f.0
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 13:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773089670; x=1773694470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdEZDCxEKJGJPro1MUUYhPOSzgUf3ELdzp1FgkKvc0s=;
        b=idtKQnvkAdPE+fBM+ehEPVmEO4sQ2BbMIYdBV9s/drd77n2rckLVvvtm0i69tr96JX
         iEbGikc8z995QuPupwgRw1MF+GqIDMTXTg76DMMqmDNIEN2fKdoMWWIWWb4bRx3hMy8G
         iP2iB5nsGYpkWTHihgeiGCTiYee26//GkKFQ5PbKEtucLRYOVOATr59HdAVcEZWAgl16
         UL0rCF4/Xizcx0mTQdK0s6zr07M5X+GmgYC0Ac96AYisvpkTmCdC9miUwf+r2uptqw9R
         nE92EtirFtPAr/F9v7BsclLfCdw5G9cN2D9WU6WFxDjyGRSJN3QAZHqZtI2i4tON3dh9
         jUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773089670; x=1773694470;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QdEZDCxEKJGJPro1MUUYhPOSzgUf3ELdzp1FgkKvc0s=;
        b=D7gKlxoobMlTMu4Yap/TOhKZPqj+jgqap+mc3WjGBinlfpmlJfj4ZcUdygdxtEOTTn
         BbyfzKNGTGIiIdNT/9oKb1nIOOyVe5show8pc06/X7TLpghpEF7xm/RBhlRUFlaBTgyA
         OMQBEZCW+z0phY8ZolKAMCcZ7+zN2QBm9bC7ZwBRa08z/xGJjJhnUFasOQhuEiMamled
         Hhv1eVcpdAVCInxO3sd7arHLdIr8NcZqA5a5t8asqrURir/KjnDFSvnfLtbTYCPVGfQD
         iMmgMmfPUUEdu4dk+Y6i3XOlVaW2LHNRXEFeZRKrtxJdNNuGUknnMy2leRLJu4yq881e
         FbEg==
X-Gm-Message-State: AOJu0Yy56/dYChYz9gE4lriQuW9ISgVDgTO3FlnGcLzID9syg4DlRFTu
	m5friCniGvWpximfAwFCWRvgN+SpMGGmMdY8orzKyzNsXwLokXkB/CXh
X-Gm-Gg: ATEYQzx95KebFT2L3k2np8/v26PlBTGiMjPlSW38QAfL2+d1SXWOxjmWihftxXkpVTE
	vAz/tDFAlGctTuZFO+myiY2VOBajJ90gRvdRiZ4FsiVQnxJ/ESNmhxZbnjBF7w3hya0MrBnISSx
	wjYStVASsJkwsGdOjU/RNbjwt8iNAzK6mezEHG9AcFdPT/fjkR+gyeGfgJOW/NqbpBxRKTVytPX
	k/WvzlE4pY6wnaaJycV1f50Rfx841FNkwJaUIsfjrrq6I6PEiWG/kMe8k2YTkMraYBVEDXFO/Tf
	8mv22WMtFyToQNoDE+12IJopxjo7P9+RG1EV1zt7Ugyveh021ri+aHzjVtLLKC/QBPJhn5fusRk
	ekJ8bQgyGyrg622ywssUh1XqJdGsIYY6spPxJ/B+gP9V9STA3OaDsumt0iXCL5fBGpQ+hzhZY0x
	JnQvviCtL3bq1OVPAa
X-Received: by 2002:a05:6000:178c:b0:439:b79d:b9a6 with SMTP id ffacd0b85a97d-439eff1bc46mr1897906f8f.11.1773089669706;
        Mon, 09 Mar 2026 13:54:29 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae57c05sm27458886f8f.39.2026.03.09.13.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 13:54:29 -0700 (PDT)
Date: Mon, 9 Mar 2026 20:54:30 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <5629bf19-9f07-45da-b32d-534f8e7dc80c@gmail.com>
In-Reply-To: <b1324259-8cad-4fef-94b9-2a72ac5e54f4@gmail.com>
References: <20260309202433.1ED14C4CEF7@smtp.kernel.org> <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com> <20260309134310.6036ef100f81a943f0fe6e2b@linux-foundation.org> <b1324259-8cad-4fef-94b9-2a72ac5e54f4@gmail.com>
Subject: Re: +
 lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <5629bf19-9f07-45da-b32d-534f8e7dc80c@gmail.com>

9 Mar 2026 20:45:45 Josh Law <hlcj1234567@gmail.com>:

> 9 Mar 2026 20:43:11 Andrew Morton <akpm@linux-foundation.org>:
>
>> On Mon, 9 Mar 2026 20:35:07 +0000 Josh Law <hlcj1234567@gmail.com> wrote=
:
>>
>>> Do you think these patches require Cc: stable?
>>> Idk the severity of the bug to you, the swapped arguments got Cc stable=
,=C2=A0 overflow could cause some screwy bugs
>>
>> Probably not - is there any reason to believe any callers will hit this?
>
> I=E2=80=99ve been looking at the callers. While most are in-kernel consta=
nts, xt_string in Netfilter allows for dynamic patterns. Even if it's curre=
ntly mitigated elsewhere, hardening the allocation logic in ts_bm and ts_km=
p feels like a 'must-have' for stable trees to prevent future heap overflow=
 vectors. Basically... Better safe than sorry!
>
>
> V/R
>
>
>
> Josh law

Yeah, I now think Cc: stable is a need for both of the overflows, I am thin=
king about that 32 bit shift aswell, but that probably won't need it
