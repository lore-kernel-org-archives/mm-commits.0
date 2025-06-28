Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175AA17799F
	for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751120423; cv=none; b=okZHM1NuHylTC1ntH9RE99lXMZQ3U05twGhkIyp7Gnla4fQz8qc3dh4rKrBp2pt0HooX6vnNwE9I/kyH/5eU2zpAmx5lNIC/+ytXiPiYzstVERr0RX6cZ7E+AebCWSt4/51NCN4PIrme4exL46k+AQA4P/hH0Oz97sTkR/JVw24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751120423; c=relaxed/simple;
	bh=EwfegH/3OO47V7KYZawOjKZpqLad0c19HbMAqoADP+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QObcZ+I3R3kgIc6NSDLHRxdl2osR//a/h0RE6V/fM6QGo2bYsIWjOAoDzxQWNqTyQSC3trVYHbcHvd019WGfhgnHChBsMKnRCFw5Mojwb0aS67k+WSWL0yNxIm1UX8dwxXDHLDzFaC7yhmvHYjN8WZENB4f4DYFRM3H6/4oB2RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rvlg5O5h; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rvlg5O5h"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad56cbc7b07so112854766b.0
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 07:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751120420; x=1751725220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=36cih8o+1UsmaDqitgukcxyFFbM/HKCoUPZMDtdYoGM=;
        b=Rvlg5O5htl0CNdhze0tiONyXl3KlCiyS09fGCGVyNn7huG9aSXUIUvUN1vpjStcRBB
         mL4nbLGMEzBkeYWgg09BMIhvTJdOOA6e1yrCsd5ZjhaXXknp5s9zwoIRKxwXq1VOC9xk
         XLiL4+2oAA+oA9tR8BMNag6I3MJvrtaCquXuI1WBTWZfJ65gdNRu1IMtyFPe5wMd6idE
         oPGdgnt1VnIJ6dCHUl+cFto8h392nt2tMPH2VMbRrv9J1448BWt5oMgz3uuXduacYDSl
         u5pWj0PCuUJUh0ADsBQ/J4luw4FaPWnggtwmkyLxcN9JGJmBy6k3Zurp2L4Gc+B7ipCQ
         kq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751120420; x=1751725220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36cih8o+1UsmaDqitgukcxyFFbM/HKCoUPZMDtdYoGM=;
        b=U3IFI63kC8F4jGMrGWAOGw1+NBPpnvJl8noq+SA4wcfhD0+FKPb3916OnUwvA4g+xB
         RRnUjjAt02JTl/bxt9gZvvrynMaAjehOirA3kVYuLsNrLapajMdZ+jClJP4/lKhZ/k9c
         h/Tr1ARqEtwdAcR0uy2eRxrQmODRnE2k9rEBganXOxJz0Y3aqMMxDk4cqNpEBCtgKV9W
         dD8z+OnHfYaEUScl3e3MgMp5ehjsBok6jSyR3LHXdsPfr8t3dTdgFbKb9L5vTJgiKBCO
         WtyiLYBagmtjVeGuvm3e9OfZisgouM1y0ObmNxXBTIwJfXB74scZtLUWK7ZCi4h6TPiy
         2MbQ==
X-Gm-Message-State: AOJu0YxMLs0lW6teBgwzmmHIhAHJ2Vio9BYxhGdkM1gZO/qVXNmhpRBq
	V+lyUPx20lVSjEbvO0LUcqrFYNNn+jvyk4jufEHTzeSg6TWp9b38Yfc=
X-Gm-Gg: ASbGnctc4LZupAyt6/f7EVtudwg/Ql72kmqiGvdi/GKecAMdciaME3us2/F0+kpyRbp
	bM8jVQUbx6/5jvaLxxxpv1zcmzTkR9dloy+3GC1bIat+YaCSrQjuJwUThAoC/5J1lKIiVnuxiHo
	kRpQWNMnNc1UDu8JiqZ/VHQ1gWyclRlaTXvNE5fHRA0N8GikaVV/F4cXrndDaMziyO86QUx6t2f
	mWnEehDqwAzhD+iAoIynMB3XOzEHHkO/XplUx/incVpY8PxCBpM12Ny/3XjtjXHnUsYYsb8FJeM
	RZ+7ivoKncDXdk9ekuJ/oMU6PR0+IUFSg0MQSdzqrXNsfzVr
X-Google-Smtp-Source: AGHT+IE2+s4RKAr1bpQ8CkEZeVmDwM/4r9lXVvT/RPumtDb3AEanJzJWV7Kv6XNPCP6VTaG6l/m/6g==
X-Received: by 2002:a17:907:3e04:b0:ae0:4820:244c with SMTP id a640c23a62f3a-ae34fcf462emr526591966b.8.1751120420013;
        Sat, 28 Jun 2025 07:20:20 -0700 (PDT)
Received: from p183 ([46.53.249.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353ca205dsm319079166b.160.2025.06.28.07.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 07:20:19 -0700 (PDT)
Date: Sat, 28 Jun 2025 17:20:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yebin10@huawei.com, willy@infradead.org,
	vbabka@suse.cz, tjmercier@google.com, shuah@kernel.org,
	ryan.roberts@arm.com, peterx@redhat.com, paulmck@kernel.org,
	osalvador@suse.de, mhocko@kernel.org, lorenzo.stoakes@oracle.com,
	linux@weissschuh.net, liam.howlett@oracle.com,
	kaleshsingh@google.com, josef@toxicpanda.com, jannh@google.com,
	hannes@cmpxchg.org, david@redhat.com, christophe.leroy@csgroup.eu,
	brauner@kernel.org, andrii@kernel.org, surenb@google.com
Subject: Re: +
 selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch added to
 mm-new branch
Message-ID: <df410ed0-054a-4867-a2f9-1baf92c2d41a@p183>
References: <20250624200751.ADDEAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624200751.ADDEAC4CEE3@smtp.kernel.org>

On Tue, Jun 24, 2025 at 01:07:50PM -0700, Andrew Morton wrote:
> The patch titled
>      Subject: selftests/proc: add /proc/pid/maps tearing from vma split test
> has been added to the -mm mm-new branch.  Its filename is
>      selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch

> From: Suren Baghdasaryan <surenb@google.com>
> Subject: selftests/proc: add /proc/pid/maps tearing from vma split test

Can this be moved to separate test?

Original is about /proc/*/maps being correct and isn't about races.
Original is amd64 only while yours is not.

And it is one-shot test not time limited.

> +	/* Test tearing in /proc/$PID/maps */
> +	if (test_maps_tearing())
> +		return 1;

This just glues 2 tests together.
