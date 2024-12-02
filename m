Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557681FC7CC
	for <mm-commits@vger.kernel.org>; Mon,  2 Dec 2024 10:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733134093; cv=none; b=T8TR+ut3AA56+pTFQcNmkw9noLISn0gGUCCsKQHTM9X6VxquP4RufuGcNOp2sUo1YzmzjbFAxDjVcUyCB1FbMIhrDl6cxe84JrQg+eV3sTER/Qm7NThuPL8io3uuqhs/uKW7Ml99ioyes+IZFI9KqJMuYcGiscDAHdP2rPjfP1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733134093; c=relaxed/simple;
	bh=OIVmsmNdrXDToCpTmqXyErNo64y8yJSsaI+V3a8WvM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kvESuTqcoM79Kv/xUzGyr7oQ+VHhzDzpJrK7pXznJRU17bEO/OzpcN8vRSFau7d8OIzPACQgNhQ7Kgrnn27g5bKSckrmUODYMp1+6TJKA7Ey9cIqEO23IceKyA7eJO+Yf11fDf1/wdmCCtNULLNHFiVZEzSoLETPJF9uxTwI3j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YtSihXAe; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtSihXAe"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-724ec3ac5d0so469782b3a.2
        for <mm-commits@vger.kernel.org>; Mon, 02 Dec 2024 02:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733134091; x=1733738891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=881KZZtbfFrnEb9pOVwYlsr1JylZL3RqaadC+W0OuLk=;
        b=YtSihXAepbaRQgS2vIj/Af/BHiWW/3NPjaRPjLpBuQDIBDerSWySHopq0bt/ptV9Da
         0/YdCL9tlhSzmwpnkkWiPAMCnMM8f7b5i3hwBJGvNjzmnTevMgQYe898nzYzXuuIUBim
         IHl99/PGSrsPRRJFWxuErSe7Aua5GeAHUtLhQFlsYKU+gHXft5qPOCFDXbVQ5131EOES
         BYGNINlO6dL+BG+QeTGLCwwhtyAhQH+maoVY7tfnu6FFGZuI8ABkrMNzuT9OxO+E070I
         jkumUDfOaWZ6JypeYg34wskuomPRdmu/JtL+/+8hETjvHiGJyKyK44AfP7NWe6jR+CFq
         y7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733134091; x=1733738891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=881KZZtbfFrnEb9pOVwYlsr1JylZL3RqaadC+W0OuLk=;
        b=rhxguU2tpvYLxKqeuG+qYaHwLpxTX/Hkf9NpNGatTQBloVfxLRbMyLTk71AVfqjN+5
         dep4sGO7jkW7x6/chIEkM6jUuPKdlTS0QOFRhLhVmCZq3j6l/LWTOxIimfuY5vq98IOV
         /48tnxt010JeAViyuOdj1JZCwOksSeIg8qPQRykoFhyUAfVyXkL7rlA4AVbzVq3eZANt
         T19DPVP8Xl1EXsWqBUUgP1AiDbPWNvSg1J1JUSn5m+RjYloutgb6skKJh4S75onsfyrw
         L+jsondsinNfxrnAeHdM8bsyVn86sLDKUM2Ljuki7U8oXQjIU70Hz/Pu7kZdfzB+zgdy
         sgpA==
X-Forwarded-Encrypted: i=1; AJvYcCWSNv4WjOVELr0Gx9LbakM86LdqaDxmlQXu7lSA8mN3EMBlfiMDcw3UxUw6cf24RcVEmJcglftse2Ae@vger.kernel.org
X-Gm-Message-State: AOJu0YyqZOXnBlshWl6ruYjJO+ODyFD9WVTJHtWMvRMKkEFYbB0Qx6mc
	ebE8HzhXsNeN1voPCombn8FUq2Ir0qTiS4BfaXcpqKiaSam4S1Z4
X-Gm-Gg: ASbGncvYUgvrCfdj5ZAxRdbAPdcROJnqK9mtbBADAn6JXhyhR7zqirAepqCTiG3Kep2
	g8UtvvgZpFhKgX9Zq0VMg3GPl0fMwD7Hv6FtCtkDy9ld4p33S5y/HYw47Q+JAG2rh9GC7W+zJFW
	+LLVAuFHPYVyg7kfOEC9r3BZ4DUxDFiq9oYe0VVHcXh7YuCsso2e2r+A3T7nqtUz5rwX8y6l+yH
	fh+8t2jdEG4I34LG8tKEKx31+Fh1abIs8eA/ERoH840+om+BLFE6w==
X-Google-Smtp-Source: AGHT+IHg4Vc/NjL9tOUPHkK/jOoRrdyN6dNGIBhSyPiwuj+dwkzqq4SwVo4Z0DxjtDTiQhh1fpELNg==
X-Received: by 2002:a17:90a:e7d2:b0:2ee:713d:f529 with SMTP id 98e67ed59e1d1-2ee713df76amr5657948a91.6.1733134091480;
        Mon, 02 Dec 2024 02:08:11 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eeaef494fcsm2338315a91.43.2024.12.02.02.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 02:08:11 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: [PATCH] zram: panic when use ext4 over zram
Date: Mon,  2 Dec 2024 18:07:53 +0800
Message-Id: <20241202100753.139305-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241130053247.GH10431@google.com>
References: <20241130053247.GH10431@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> What's your use-case, what apps you run and what data is stored
> on zram disk?

The steps to reproduce are as follows:

1. force slow path,then re-build kernel

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0ca6d55c9917..29ac52a4f2e7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1683,12 +1683,14 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
         * if we have a 'non-null' handle here then we are coming
         * from the slow path and handle has already been allocated.
         */
+    /*
        if (IS_ERR_VALUE(handle))
                handle = zs_malloc(zram->mem_pool, comp_len,
                                __GFP_KSWAPD_RECLAIM |
                                __GFP_NOWARN |
                                __GFP_HIGHMEM |
                                __GFP_MOVABLE);
+        */
        if (IS_ERR_VALUE(handle)) {
                zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
                atomic64_inc(&zram->stats.writestall);

2. create an arm64 virtual machine

qemu-system-aarch64 -M virt -cpu cortex-a57 -smp 4 -m 1024 -kernel kernel-build/arch/arm64/boot/Image \ 
    -nographic -append "console=ttyAMA0,115200 root=/dev/vda rw" \ 
    -drive file=$(IMGFILE),format=raw -nic user,hostfwd=tcp::60022-:22

3. after the virtual machine is started, create zram

cat /sys/class/zram-control/hot_add
echo 524288000 > /sys/devices/virtual/block/zram0/disksize
echo 524288000 > /sys/devices/virtual/block/zram1/disksize
mkfs.ext4 -O ^has_journal -b 4096 -F -L TEMP -m 0 /dev/zram0
mkdir /tmp/zram
mount -t ext4 -o errors=continue,nosuid,nodev,noatime /dev/zram0 /tmp/zram
mkswap /dev/zram1
swapon /dev/zram1
echo 100 > /proc/sys/vm/swappiness
mkdir -p /tmp/zram/stressTest


4. build demo app and run again and again

demo app :

#include <stdio.h>
#include <sys/mman.h>
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <string.h>
#include <syscall.h>

#define THREAD_NUM      400
#define BUFF_SIZE       128*1024

const static char * basePath = "/tmp/zram/stressTest";
static unsigned char buf[BUFF_SIZE];

void * cb(void * arg){

    char path[256];
    unsigned int tid = (unsigned int)(syscall(SYS_gettid));
    unsigned int start = ((unsigned int)random())%(BUFF_SIZE - 1);
    unsigned int msleep = (((unsigned int)random())%10) * 1000;
    void * p;
    int i;

    snprintf(path,sizeof(path) - 1,"%s/%u",basePath,tid);

    FILE * fp = fopen(path,"a");

    if (NULL == fp) {
        fprintf(stderr,"%u open file '%s' failure '%s'...\n",tid,path,strerror(errno));
        return NULL;
    }

    start = ((unsigned int)random())%(BUFF_SIZE - 1);
    fwrite(&buf[start],1,BUFF_SIZE - start,fp);
    fflush(fp);
    fclose(fp);
    sync();
    usleep(msleep);

    return NULL;
}

int main(int argc, char *argv[]) {

    pthread_t pid[THREAD_NUM];
    int i;

    fprintf(stderr,"build @ %s\n",__TIME__);

    FILE * fp = fopen("/dev/urandom","ro");
    fread(buf,BUFF_SIZE,1,fp);
    fclose(fp);

    fprintf(stderr,"read urandom size '%d'\n",BUFF_SIZE);
    srandom((unsigned)time(NULL));

    for (i = 0;i < THREAD_NUM;i++) {
        pthread_create(&pid[i],NULL,cb,NULL);
    }

    fprintf(stderr,"create over\n");

    for (i = 0;i < THREAD_NUM;i++) {
        pthread_join(pid[i],NULL);
    }

    return 0;
}


run it

while true;do rm /tmp/zram_vsd/stressTest/* &> /dev/null;./a.out &> /dev/null ;echo again...;done
